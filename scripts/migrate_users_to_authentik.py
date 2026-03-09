#!/usr/bin/env python3
"""
Migrate platform users to Authentik, preserving their existing password hashes.

This script reads users from the platform's PostgreSQL database, creates them
in Authentik via the REST API, then injects their converted Argon2 password
hash directly into Authentik's database — so users can log in without a reset.

Password hash conversion:
  passlib (platform):  $argon2id$v=19$m=...,t=...,p=...$salt$hash
  Django (Authentik):  argon2$argon2id$v=19$m=...,t=...,p=...$salt$hash
  (only difference: prepend "argon2" to the passlib PHC string)

Usage:
    # Migrate specific users by platform user ID
    python migrate_users_to_authentik.py --ids 1 2 3

    # Migrate specific users by email
    python migrate_users_to_authentik.py --emails alice@example.com bob@example.com

    # Dry run (no changes made)
    python migrate_users_to_authentik.py --ids 1 2 3 --dry-run

Required environment variables:
    PLATFORM_DB_URL      postgresql://postgres:postgres@localhost:5432/postgres
    AUTHENTIK_URL        https://nei.web.ua.pt/authentik
    AUTHENTIK_TOKEN      <admin API token from Authentik UI>
    AUTHENTIK_DB_URL     postgresql://authentik:pass@authentik-db:5432/authentik

Dependencies (install with pip):
    psycopg2-binary requests
"""

import argparse
import os
import sys
import textwrap
from dataclasses import dataclass
from typing import Optional

try:
    import psycopg2
    import psycopg2.extras
    import requests
except ImportError:
    print("Missing dependencies. Run: pip install psycopg2-binary requests")
    sys.exit(1)


# ---------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------

@dataclass
class PlatformUser:
    id: int
    name: str
    surname: str
    email: Optional[str]
    hashed_password: Optional[str]  # passlib argon2 PHC string or None (OIDC user)
    nmec: Optional[int]
    scopes: list


# ---------------------------------------------------------------------------
# Platform DB helpers
# ---------------------------------------------------------------------------

def fetch_users_by_ids(conn, ids: list[int]) -> list[PlatformUser]:
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute(
            """
            SELECT u.id, u.name, u.surname, u.hashed_password, u.nmec, u.scopes,
                   ue.email
            FROM nei.user u
            LEFT JOIN nei.user_email ue ON ue.user_id = u.id AND ue.active = true
            WHERE u.id = ANY(%s)
            """,
            (ids,),
        )
        return [_row_to_user(r) for r in cur.fetchall()]


def fetch_users_by_emails(conn, emails: list[str]) -> list[PlatformUser]:
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute(
            """
            SELECT u.id, u.name, u.surname, u.hashed_password, u.nmec, u.scopes,
                   ue.email
            FROM nei.user u
            JOIN nei.user_email ue ON ue.user_id = u.id AND ue.active = true
            WHERE ue.email = ANY(%s)
            """,
            (emails,),
        )
        return [_row_to_user(r) for r in cur.fetchall()]


def _row_to_user(row: dict) -> PlatformUser:
    return PlatformUser(
        id=row["id"],
        name=row["name"],
        surname=row["surname"],
        email=row["email"],
        hashed_password=row["hashed_password"],
        nmec=row["nmec"],
        scopes=row["scopes"] or [],
    )


# ---------------------------------------------------------------------------
# Password hash conversion
# ---------------------------------------------------------------------------

def passlib_to_django_argon2(passlib_hash: str) -> str:
    """
    Convert a passlib argon2 PHC string to Django/Authentik format.

    passlib: $argon2id$v=19$m=65536,t=2,p=2$<salt>$<hash>
    Django:  argon2$argon2id$v=19$m=65536,t=2,p=2$<salt>$<hash>
    """
    if not passlib_hash.startswith("$argon2"):
        raise ValueError(
            f"Expected passlib argon2 hash starting with '$argon2', got: {passlib_hash[:20]}..."
        )
    return "argon2" + passlib_hash


# ---------------------------------------------------------------------------
# Authentik API helpers
# ---------------------------------------------------------------------------

class AuthentikAPI:
    def __init__(self, base_url: str, token: str, verify_ssl: bool = True):
        self.base = base_url.rstrip("/")
        self.session = requests.Session()
        self.session.headers.update({"Authorization": f"Bearer {token}"})
        self.verify_ssl = verify_ssl

    def _get(self, path: str, params: dict = None) -> dict:
        r = self.session.get(f"{self.base}/api/v3{path}", params=params, verify=self.verify_ssl)
        r.raise_for_status()
        return r.json()

    def _post(self, path: str, json: dict) -> dict:
        r = self.session.post(f"{self.base}/api/v3{path}", json=json, verify=self.verify_ssl)
        r.raise_for_status()
        return r.json()

    def find_user_by_email(self, email: str) -> Optional[dict]:
        result = self._get("/core/users/", params={"email": email})
        results = result.get("results", [])
        return results[0] if results else None

    def create_user(self, user: PlatformUser) -> dict:
        """Create user in Authentik (without password — injected separately)."""
        username = user.email.split("@")[0] if user.email else f"user_{user.id}"
        payload = {
            "username": username,
            "name": f"{user.name} {user.surname}".strip(),
            "email": user.email or "",
            "is_active": True,
            "type": "internal",
            "attributes": {
                "platform_id": user.id,
                "nmec": user.nmec,
                "platform_scopes": user.scopes,
            },
        }
        return self._post("/core/users/", json=payload)


# ---------------------------------------------------------------------------
# Authentik DB helpers
# ---------------------------------------------------------------------------

def inject_password_hash(authentik_conn, authentik_user_pk: int, django_hash: str, dry_run: bool):
    """Write the converted password hash into Authentik's user table."""
    if len(django_hash) > 128:
        print(f"    WARNING: hash length {len(django_hash)} > 128 chars (column max_length).")
        print(f"             This may be truncated or rejected. Skipping hash injection.")
        return False

    if dry_run:
        print(f"    [dry-run] Would write hash (len={len(django_hash)}) to authentik_core_user pk={authentik_user_pk}")
        return True

    with authentik_conn.cursor() as cur:
        cur.execute(
            "UPDATE authentik_core_user SET password = %s WHERE pk = %s",
            (django_hash, authentik_user_pk),
        )
    authentik_conn.commit()
    return True


# ---------------------------------------------------------------------------
# Main migration logic
# ---------------------------------------------------------------------------

def migrate_user(
    user: PlatformUser,
    api: AuthentikAPI,
    authentik_conn,
    dry_run: bool,
) -> bool:
    print(f"\n  User #{user.id} — {user.name} {user.surname} <{user.email}>")

    if not user.email:
        print("    SKIP: no active email on record.")
        return False

    # Check if already exists in Authentik
    existing = api.find_user_by_email(user.email)
    if existing:
        authentik_pk = existing["pk"]
        print(f"    Found existing Authentik user pk={authentik_pk} — will update hash only.")
    else:
        if dry_run:
            print(f"    [dry-run] Would create Authentik user for {user.email}")
            authentik_pk = None
        else:
            created = api.create_user(user)
            authentik_pk = created["pk"]
            print(f"    Created Authentik user pk={authentik_pk}")

    # Handle password
    if not user.hashed_password:
        print("    NOTE: no password hash (OIDC-only user). Skipping hash injection.")
        print("          User will need to set a password in Authentik or use SSO.")
        return True

    django_hash = passlib_to_django_argon2(user.hashed_password)

    if authentik_pk is None:
        print(f"    [dry-run] Would inject hash (len={len(django_hash)})")
        return True

    ok = inject_password_hash(authentik_conn, authentik_pk, django_hash, dry_run)
    if ok:
        print(f"    Password hash injected successfully (len={len(django_hash)}).")

    return ok


def main():
    parser = argparse.ArgumentParser(
        description="Migrate platform users to Authentik with password hash preservation.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent("""
            Environment variables:
              PLATFORM_DB_URL      Platform PostgreSQL URL
              AUTHENTIK_URL        Authentik base URL (e.g. https://nei.web.ua.pt/authentik)
              AUTHENTIK_TOKEN      Authentik admin API token
              AUTHENTIK_DB_URL     Authentik PostgreSQL URL
        """),
    )
    parser.add_argument("--ids", nargs="+", type=int, metavar="ID",
                        help="Platform user IDs to migrate")
    parser.add_argument("--emails", nargs="+", metavar="EMAIL",
                        help="Platform user emails to migrate")
    parser.add_argument("--dry-run", action="store_true",
                        help="Preview what would happen without making any changes")
    parser.add_argument("--no-verify-ssl", action="store_true",
                        help="Disable SSL verification (for self-signed certs)")
    args = parser.parse_args()

    if not args.ids and not args.emails:
        parser.error("Provide at least --ids or --emails")

    # Read env vars
    platform_db_url = os.environ.get("PLATFORM_DB_URL", "postgresql://postgres:postgres@localhost:5432/postgres")
    authentik_url   = os.environ.get("AUTHENTIK_URL")
    authentik_token = os.environ.get("AUTHENTIK_TOKEN")
    authentik_db_url = os.environ.get("AUTHENTIK_DB_URL")

    missing = [k for k, v in {
        "AUTHENTIK_URL": authentik_url,
        "AUTHENTIK_TOKEN": authentik_token,
        "AUTHENTIK_DB_URL": authentik_db_url,
    }.items() if not v]
    if missing:
        print(f"Missing required environment variables: {', '.join(missing)}")
        sys.exit(1)

    if args.dry_run:
        print("=== DRY RUN — no changes will be made ===\n")

    # Connect to both databases
    print("Connecting to platform database...")
    platform_conn = psycopg2.connect(platform_db_url)

    print("Connecting to Authentik database...")
    if args.dry_run:
        authentik_conn = None
    else:
        authentik_conn = psycopg2.connect(authentik_db_url)

    api = AuthentikAPI(authentik_url, authentik_token, verify_ssl=not args.no_verify_ssl)

    # Fetch users from platform DB
    users = []
    if args.ids:
        users += fetch_users_by_ids(platform_conn, args.ids)
    if args.emails:
        users += fetch_users_by_emails(platform_conn, args.emails)

    if not users:
        print("No users found matching the given criteria.")
        sys.exit(0)

    print(f"\nFound {len(users)} user(s) to migrate:")
    for u in users:
        has_pw = "has password" if u.hashed_password else "no password (OIDC)"
        print(f"  #{u.id} {u.name} {u.surname} <{u.email}> [{has_pw}]")

    print("\n--- Starting migration ---")
    ok_count = 0
    fail_count = 0
    for user in users:
        try:
            success = migrate_user(user, api, authentik_conn, args.dry_run)
            if success:
                ok_count += 1
            else:
                fail_count += 1
        except Exception as e:
            print(f"    ERROR: {e}")
            fail_count += 1

    platform_conn.close()
    if authentik_conn:
        authentik_conn.close()

    print(f"\n--- Done: {ok_count} succeeded, {fail_count} failed ---")
    if args.dry_run:
        print("(dry run — no actual changes were made)")


if __name__ == "__main__":
    main()
