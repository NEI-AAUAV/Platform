"""add directus least-privilege db role

Revision ID: d3c7f0a1b2e4
Revises: d4e5f6a7b8c9
Create Date: 2026-09-18

Creates a dedicated Postgres role for the standalone `nei-directus` service
(separate repo, connects to this database over the network):

- SELECT/INSERT/UPDATE/DELETE on the specific `nei.*` tables Directus is
  allowed to manage, starting with `rgm`. Extend `MANAGED_TABLES` as more
  content areas (`note`, `team_member`, ...) are onboarded — see
  nei-directus/README.md.
- A dedicated `directus` schema, owned by this role, for Directus's own
  `directus_*` system tables (collections, fields, permissions, files...).
  These must not live in `nei` — that schema is api-nei's, and Directus's
  bootstrap needs CREATE TABLE rights somewhere, which we don't want to
  grant on `nei`.
- `search_path` set to `directus, nei` (deliberately NOT `public` — see
  below) so Directus's default (schema-less) queries land in `directus`,
  while `nei.<table>` is still reachable for the collections it's
  configured to manage.

Two hard-won constraints, from getting this actually running against a
real Postgres:

1. Directus's schema introspection only recognizes `BASE TABLE`s, not
   `VIEW`s (`information_schema.tables.table_type`). A same-schema view
   bridging to `nei.rgm` (to avoid touching `search_path` at all) does
   NOT work — Directus reports "does not exist" for it. `nei` has to be
   on the search_path directly.
2. `information_schema.tables` only lists tables a role has some
   privilege on — so putting `nei` on the search_path is safe *because*
   `directus_svc` is only ever granted on `MANAGED_TABLES`, not the whole
   schema. `public` must stay off the search_path though: it isn't
   privilege-gated the same way in practice on a shared dev Postgres, and
   pulled in an unrelated `public.app_setting` table from another service
   sharing this instance, which crashed Directus's startup (it tries to
   read primary-key metadata for every visible table, not just ones it
   manages, and chokes on ones it doesn't recognize).

Does NOT grant DDL rights on `nei`: schema changes to api-nei's own tables
stay in api-nei's Alembic migrations, never in Directus's own schema-apply.

NOTE (2026-09-19): `d4e5f6a7b8c9` and its predecessor `c3d4e5f6a7b8` are now
committed, so `alembic upgrade head` closes to a single head again.

NOTE (2026-09-18, superseded): this grant was previously also applied at
runtime by `nei-directus/sql/01-grants.sql` on every deploy of that
separate repo. That duplication is retired as of e8f0a2b4c6d8:
Infrastructure now runs `alembic upgrade head` against this schema as
part of its own deploy (see Infrastructure/services/directus/scripts/
provision-db.sh), so this migration chain is the single source of truth
for `nei.*` DDL and `directus_svc` grants — Infrastructure's own SQL is
reduced to creating the `directus_svc` login role and the `directus`
schema, which must exist before Directus (a separate service) can even
attempt to connect.

The role's login password is set separately (out of band, via `ALTER ROLE
... PASSWORD` run manually or by ops tooling) — never hardcode a password
in a migration file.
"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "d3c7f0a1b2e4"
down_revision = "d4e5f6a7b8c9"
branch_labels = None
depends_on = None

ROLE_NAME = "directus_svc"
APP_SCHEMA = "nei"
DIRECTUS_SCHEMA = "directus"
MANAGED_TABLES = ["rgm"]


def upgrade():
    op.execute(
        f"""
        DO $$
        BEGIN
            IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '{ROLE_NAME}') THEN
                CREATE ROLE {ROLE_NAME} WITH LOGIN;
            END IF;
        END
        $$;
        """
    )

    op.execute(f"GRANT USAGE ON SCHEMA {APP_SCHEMA} TO {ROLE_NAME};")
    for table in MANAGED_TABLES:
        op.execute(
            f"GRANT SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{table} TO {ROLE_NAME};"
        )
    op.execute(
        f"GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA {APP_SCHEMA} TO {ROLE_NAME};"
    )

    op.execute(f"CREATE SCHEMA IF NOT EXISTS {DIRECTUS_SCHEMA} AUTHORIZATION {ROLE_NAME};")
    op.execute(f"GRANT ALL PRIVILEGES ON SCHEMA {DIRECTUS_SCHEMA} TO {ROLE_NAME};")
    op.execute(
        f"ALTER ROLE {ROLE_NAME} SET search_path TO {DIRECTUS_SCHEMA}, {APP_SCHEMA};"
    )


def downgrade():
    op.execute(f"ALTER ROLE {ROLE_NAME} RESET search_path;")
    op.execute(f"DROP SCHEMA IF EXISTS {DIRECTUS_SCHEMA} CASCADE;")

    for table in MANAGED_TABLES:
        op.execute(
            f"REVOKE SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{table} FROM {ROLE_NAME};"
        )
    op.execute(f"REVOKE USAGE ON SCHEMA {APP_SCHEMA} FROM {ROLE_NAME};")
    op.execute(
        f"""
        DO $$
        BEGIN
            IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '{ROLE_NAME}') THEN
                DROP ROLE {ROLE_NAME};
            END IF;
        END
        $$;
        """
    )
