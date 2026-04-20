"""
OIDC/OpenID Connect authentication endpoints for Authentik integration.

Flow
----
Login:
  1. GET /auth/oidc/login  →  redirect to Authentik with a signed state cookie
  2. GET /auth/oidc/callback  →  verify state, exchange code, upsert user, redirect to frontend

Account linking (allows existing password users to link to Authentik SSO):
  1. POST /auth/oidc/link  →  redirect to Authentik with signed state cookie (contains user_id)
  2. GET /auth/oidc/link-callback  →  verify state, set authentik_sub on existing user

State / CSRF protection
-----------------------
A random nonce is generated on /oidc/login and /oidc/link.  It is:
  - Sent as the `state` query parameter to Authentik (so Authentik echoes it back).
  - Stored in a short-lived, HttpOnly, signed cookie (using itsdangerous).

On callback the cookie is read, the signature is verified, and the nonce is
compared to the `state` parameter returned by Authentik.  Any mismatch or
missing cookie is rejected with 401.

Scopes
------
Scopes are resolved from OIDC claims on every login (Authentik is the source of
truth).  The `scopes` claim is checked first (set via nei_scopes property mapping
in Authentik).  Falls back to `groups`, stripping an optional "nei-" prefix.
"""

import json
import secrets
from typing import Annotated, Any, Optional
from urllib.parse import quote, unquote

import httpx
from authlib.integrations.starlette_client import OAuth
from authlib.jose import JsonWebKey, jwt
from authlib.jose.errors import JoseError
from sqlalchemy.exc import IntegrityError
from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from fastapi.responses import RedirectResponse
from itsdangerous import BadSignature, SignatureExpired, URLSafeTimedSerializer
from loguru import logger
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.core.config import settings
from app.models.user import User
from app.models.user.user_email import UserEmail
from app.schemas.user import ScopeEnum, UserCreate

from ._deps import AuthData, Token, generate_response, private_key, verify_token

DbSession = Annotated[Session, Depends(deps.get_db)]
CurrentUser = Annotated[AuthData, Depends(verify_token)]

router = APIRouter()


# ---------------------------------------------------------------------------
# OAuth client setup
# ---------------------------------------------------------------------------

oauth = OAuth()

if settings.OIDC_ENABLED:
    client_kwargs: dict = {
        "scope": " ".join(settings.OIDC_SCOPES),
        "token_endpoint_auth_method": "client_secret_post",
        "code_challenge_method": "S256",
    }
    if not settings.PRODUCTION:
        client_kwargs["verify"] = False

    oauth.register(
        name="authentik",
        client_id=settings.OIDC_CLIENT_ID,
        client_secret=settings.OIDC_CLIENT_SECRET,
        server_metadata_url=settings.OIDC_DISCOVERY_URL,
        client_kwargs=client_kwargs,
    )


# ---------------------------------------------------------------------------
# State cookie helpers
# ---------------------------------------------------------------------------

_STATE_COOKIE = "oauth_state"
_STATE_MAX_AGE = 600  # 10 minutes


def _signer() -> URLSafeTimedSerializer:
    return URLSafeTimedSerializer(private_key)


def _set_state_cookie(
    response: Response,
    state: str,
    *,
    oidc_nonce: Optional[str] = None,
    redirect_to: Optional[str] = None,
    user_id: Optional[int] = None,
    code_verifier: Optional[str] = None,
) -> None:
    payload: dict = {"s": state}
    if oidc_nonce:
        payload["n"] = oidc_nonce
    if redirect_to:
        payload["r"] = redirect_to
    if user_id is not None:
        payload["u"] = user_id
    if code_verifier:
        payload["v"] = code_verifier
    response.set_cookie(
        _STATE_COOKIE,
        _signer().dumps(payload),
        httponly=True,
        secure=settings.PRODUCTION,
        samesite="lax",
        max_age=_STATE_MAX_AGE,
    )


def _verify_and_pop_state_cookie(request: Request, response: Response, state: str) -> dict:
    cookie_val = request.cookies.get(_STATE_COOKIE)
    response.delete_cookie(_STATE_COOKIE, httponly=True, samesite="lax")

    if not cookie_val:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Missing OAuth state cookie")

    try:
        payload = _signer().loads(cookie_val, max_age=_STATE_MAX_AGE)
    except SignatureExpired:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "OAuth state expired — please try again")
    except BadSignature:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid OAuth state")

    # Constant-time comparison; also handle the pre-migration "n" key for
    # cookies issued by the previous version of this code.
    stored = payload.get("s") or payload.get("n")
    if not stored or not secrets.compare_digest(stored, state):
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "OAuth state mismatch")

    return payload


# ---------------------------------------------------------------------------
# Authentik helpers
# ---------------------------------------------------------------------------

def _is_safe_redirect(value: Optional[str]) -> bool:
    """Only allow relative, same-origin paths. Blocks open-redirect payloads
    like '//evil.com', 'http://evil.com', percent-encoded variants, and
    whitespace-prefixed bypasses. Decoded once, then re-checked."""
    if not value or not isinstance(value, str):
        return False
    v = value.strip()
    try:
        decoded = unquote(v).strip()
    except Exception:
        return False
    for candidate in (v, decoded):
        if not candidate.startswith("/"):
            return False
        if len(candidate) > 1 and candidate[1] in ("/", "\\", "\t", " ", "\n", "\r"):
            return False
    return True


def _is_email_verified(claim: Any) -> bool:
    """Accept `email_verified` only if it's the boolean True or the string
    'true' (case-insensitive). All other values — False, "false", 0, 1,
    None, missing — return False. This avoids Python's boolean trap where
    bool("false") is True."""
    return claim is True or (isinstance(claim, str) and claim.lower() == "true")


def _callback_uri() -> str:
    return f"{settings.OIDC_REDIRECT_BASE_URL}{settings.API_V1_STR}/auth/oidc/callback"


def _link_callback_uri() -> str:
    return f"{settings.OIDC_REDIRECT_BASE_URL}{settings.API_V1_STR}/auth/oidc/link-callback"


async def _load_endpoints() -> tuple[str, str]:
    meta = await oauth.authentik.load_server_metadata()
    return meta["token_endpoint"], meta["userinfo_endpoint"]


async def _fetch_jwks(jwks_uri: str) -> dict:
    verify_ssl = settings.PRODUCTION
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        resp = await client.get(jwks_uri)
        resp.raise_for_status()
        return resp.json()


async def _validate_id_token(
    id_token: str,
    *,
    expected_nonce: Optional[str],
    expected_sub: Optional[str],
) -> None:
    """Validate the ID token's signature, issuer, audience, expiry, and nonce.

    Raises HTTPException(401) on any validation failure. The token is
    authoritative for identity claims; the userinfo response is only trusted
    after this passes.
    """
    meta = await oauth.authentik.load_server_metadata()
    jwks = await _fetch_jwks(meta["jwks_uri"])
    key_set = JsonWebKey.import_key_set(jwks)

    claims_options = {
        "iss": {"essential": True, "values": [meta["issuer"]]},
        "aud": {"essential": True, "values": [settings.OIDC_CLIENT_ID]},
        "exp": {"essential": True},
    }
    try:
        claims = jwt.decode(id_token, key_set, claims_options=claims_options)
        claims.validate()
    except JoseError as e:
        logger.warning(f"ID token validation failed: {e}")
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid ID token")

    if expected_nonce and claims.get("nonce") != expected_nonce:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "ID token nonce mismatch")

    if expected_sub and claims.get("sub") != expected_sub:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "ID token subject mismatch")


async def _exchange_code(
    code: str,
    redirect_uri: str,
    token_endpoint: str,
    userinfo_endpoint: str,
    code_verifier: Optional[str] = None,
) -> tuple[dict, Optional[str]]:
    """Returns (userinfo, id_token)."""
    verify_ssl = settings.PRODUCTION
    token_data = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirect_uri,
        "client_id": settings.OIDC_CLIENT_ID,
        "client_secret": settings.OIDC_CLIENT_SECRET,
    }
    if code_verifier:
        token_data["code_verifier"] = code_verifier
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        token_resp = await client.post(
            token_endpoint,
            data=token_data,
        )
        token_resp.raise_for_status()
        token = token_resp.json()

        userinfo_resp = await client.get(
            userinfo_endpoint,
            headers={"Authorization": f"Bearer {token['access_token']}"},
        )
        userinfo_resp.raise_for_status()
        return userinfo_resp.json(), token.get("id_token")


# ---------------------------------------------------------------------------
# User upsert
# ---------------------------------------------------------------------------

def _candidates_from_scopes_claim(raw) -> list[str]:
    if isinstance(raw, str):
        return raw.split()
    if isinstance(raw, list):
        return raw
    return []


def _candidates_from_groups(userinfo: dict) -> list[str]:
    candidates = []
    for group in userinfo.get("groups", []):
        name = group.strip().lower()
        if name.startswith("nei-"):
            name = name[4:]
        candidates.append(name)
    return candidates


def _parse_scopes(userinfo: dict) -> list[str]:
    """Resolve platform scopes from OIDC claims.

    Checks the `scopes` claim first (set via nei_scopes property mapping in
    Authentik).  Falls back to `groups`, stripping an optional "nei-" prefix.
    """
    raw = userinfo.get("scopes")
    candidates = (
        _candidates_from_scopes_claim(raw)
        if raw is not None
        else _candidates_from_groups(userinfo)
    )

    valid = []
    for s in candidates:
        try:
            valid.append(ScopeEnum(s.strip().lower()).value)
        except ValueError:
            logger.warning(f"Unknown scope from Authentik: {s!r} — skipping")
    return valid or ["default"]


def _parse_name(userinfo: dict) -> tuple[str, str]:
    first_name = userinfo.get("first_name", "").strip()
    last_name = userinfo.get("last_name", "").strip()
    if not first_name:
        name_parts = userinfo.get("name", "").split(" ", 1)
        first_name = name_parts[0].strip()
        last_name = (name_parts[1] if len(name_parts) > 1 else "").strip()
    return first_name[:20] or "User", last_name[:20]


def _find_user_by_sub_or_email(
    db: Session,
    authentik_sub: str,
    email: str,
    *,
    email_verified: bool,
) -> Optional[User]:
    user = db.query(User).filter(User.authentik_sub == authentik_sub).first()
    if user:
        return user

    # Auto-linking by email requires a verified email
    if not email_verified:
        return None

    email_row = db.query(UserEmail).filter(UserEmail.email == email).first()
    if not email_row:
        return None
    user = db.query(User).filter(User.id == email_row.user_id).first()
    if user:
        logger.info(f"Auto-linking user {user.id} to Authentik sub {authentik_sub!r}")
    return user


def _sync_user(db: Session, user: User, *, authentik_sub: str, name: str, surname: str,
               nmec: Optional[int], iupi: Optional[str], scopes: list[str]) -> bool:
    changed = False

    def _set(attr: str, value) -> None:
        nonlocal changed
        if value is not None and getattr(user, attr) != value:
            setattr(user, attr, value)
            changed = True

    _set("authentik_sub", authentik_sub)
    _set("name", name)
    _set("surname", surname)
    _set("nmec", nmec)
    _set("iupi", iupi)
    if scopes and set(user.scopes or []) != set(scopes):
        user.scopes = scopes
        changed = True

    if changed:
        db.commit()
        db.refresh(user)
    return changed


async def _sync_authentik_user_name(email: str, full_name: str) -> None:
    """Best-effort update of the Authentik user's display name."""
    if not settings.AUTHENTIK_TOKEN or not full_name:
        return
    try:
        verify_ssl = settings.PRODUCTION
        headers = {"Authorization": f"Bearer {settings.AUTHENTIK_TOKEN}"}
        async with httpx.AsyncClient(verify=verify_ssl) as client:
            resp = await client.get(
                f"{settings.AUTHENTIK_URL}/api/v3/core/users/",
                params={"email": email},
                headers=headers,
            )
            resp.raise_for_status()
            users = resp.json().get("results", [])
            if not users:
                return
            ak_user = users[0]
            if ak_user.get("name") == full_name:
                return
            await client.patch(
                f"{settings.AUTHENTIK_URL}/api/v3/core/users/{ak_user['pk']}/",
                json={"name": full_name},
                headers=headers,
            )
            logger.info(f"Synced Authentik user {ak_user['pk']} name to {full_name!r}")
    except httpx.HTTPError as e:
        logger.warning(f"Failed to sync Authentik user name: {e}")


def get_or_create_user_from_oidc(db: Session, userinfo: dict) -> User:
    """Get or create a platform user from Authentik userinfo, syncing on every login."""
    authentik_sub = userinfo.get("sub")
    email = userinfo.get("email")
    email_verified = _is_email_verified(userinfo.get("email_verified"))

    if not authentik_sub or not email:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Invalid OIDC response: missing sub or email",
        )

    # Reject logins with an unverified email: we cannot safely trust the
    # email claim (for auto-linking or for new-account creation) otherwise.
    if not email_verified:
        logger.warning(f"Rejecting OIDC login with unverified email: {email!r}")
        raise HTTPException(
            status.HTTP_403_FORBIDDEN,
            "Email is not verified in the identity provider",
        )

    name, surname = _parse_name(userinfo)
    # Defensive coercion: Authentik property mappings are user-authored Python
    # and may emit the wrong type (list/dict) if misconfigured. Discard
    # unparseable values rather than crash downstream DB writes.
    _raw_nmec = userinfo.get("nmec")
    nmec: Optional[int] = None
    if isinstance(_raw_nmec, int):
        nmec = _raw_nmec
    elif isinstance(_raw_nmec, str) and _raw_nmec.isdigit():
        nmec = int(_raw_nmec)

    _raw_iupi = userinfo.get("iupi")
    iupi: Optional[str] = (
        _raw_iupi[:64] if isinstance(_raw_iupi, str) and _raw_iupi else None
    )
    scopes = _parse_scopes(userinfo)

    user = _find_user_by_sub_or_email(
        db, authentik_sub, email, email_verified=email_verified
    )

    if user:
        changed = _sync_user(db, user, authentik_sub=authentik_sub, name=name,
                             surname=surname, nmec=nmec, iupi=iupi, scopes=scopes)
        logger.info(f"OIDC login: user {user.id} ({'synced' if changed else 'unchanged'})")
        return user

    logger.info(f"Creating new user from Authentik: {email!r}")
    try:
        user = crud.user.create(
            db=db,
            obj_in=UserCreate(
                name=name,
                surname=surname,
                email=email,
                password=None,
                scopes=scopes,
                nmec=nmec,
                iupi=iupi,
            ),
            active=True,
        )
        user.authentik_sub = authentik_sub
        db.commit()
        db.refresh(user)
        logger.info(f"Created user {user.id} from Authentik")
        return user
    except IntegrityError:
        db.rollback()
        user = _find_user_by_sub_or_email(db, authentik_sub, email, email_verified=True)
        if user:
            logger.info(f"Concurrent create race resolved: returning user {user.id}")
            return user
        raise


# ---------------------------------------------------------------------------
# Guard
# ---------------------------------------------------------------------------

def _require_oidc() -> None:
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE,
            "OIDC authentication is not enabled",
        )


def _login_error_redirect(code: str) -> RedirectResponse:
    """Send the user back to the frontend login page with an error code so the
    UI can render a specific, actionable message instead of raw JSON."""
    return RedirectResponse(
        url=f"{settings.OIDC_REDIRECT_BASE_URL}/auth/login?error={quote(code, safe='')}",
        status_code=302,
    )


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------

@router.get(
    "/oidc/login",
    responses={503: {"description": "OIDC authentication is disabled"}},
)
async def oidc_login(
    response: Response,
    redirect_to: Optional[str] = None,
):
    _require_oidc()

    # Silently drop unsafe redirects rather than failing the login flow.
    safe_redirect = redirect_to if _is_safe_redirect(redirect_to) else None
    if redirect_to and not safe_redirect:
        logger.warning(f"Rejecting unsafe redirect_to: {redirect_to!r}")

    state = secrets.token_urlsafe(32)
    oidc_nonce = secrets.token_urlsafe(32)
    await oauth.authentik.load_server_metadata()
    auth_url_data = await oauth.authentik.create_authorization_url(
        _callback_uri(), state=state, nonce=oidc_nonce,
    )

    redirect_response = RedirectResponse(url=auth_url_data["url"])
    _set_state_cookie(
        redirect_response,
        state,
        oidc_nonce=oidc_nonce,
        redirect_to=safe_redirect,
        code_verifier=auth_url_data.get("code_verifier"),
    )
    return redirect_response


@router.get(
    "/oidc/callback",
    responses={
        401: {"description": "Authentication failed or invalid state"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def oidc_callback(
    request: Request,
    response: Response,
    code: str,
    state: str,
    db: DbSession,
):
    _require_oidc()

    state_payload = _verify_and_pop_state_cookie(request, response, state)
    raw_redirect = state_payload.get("r")
    redirect_to = raw_redirect if _is_safe_redirect(raw_redirect) else None
    code_verifier = state_payload.get("v")
    expected_nonce = state_payload.get("n")

    try:
        token_endpoint, userinfo_endpoint = await _load_endpoints()
        userinfo, id_token = await _exchange_code(
            code, _callback_uri(), token_endpoint, userinfo_endpoint,
            code_verifier=code_verifier,
        )

        if not id_token:
            raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Missing ID token from identity provider")
        await _validate_id_token(
            id_token,
            expected_nonce=expected_nonce,
            expected_sub=userinfo.get("sub"),
        )

        logger.debug(
            "OIDC userinfo received (sub={}, groups={}, scopes={})",
            userinfo.get("sub"),
            userinfo.get("groups"),
            userinfo.get("scopes"),
        )

        user = get_or_create_user_from_oidc(db, userinfo)

        # Sync display name back to Authentik (best-effort, non-blocking)
        email = userinfo.get("email", "")
        first_name = userinfo.get("first_name", "")
        last_name = userinfo.get("last_name", "")
        full_name = f"{first_name} {last_name}".strip()
        if full_name:
            await _sync_authentik_user_name(email, full_name)

        token_response = generate_response(db, user, oidc_id_token=id_token)
        access_token = json.loads(token_response.body)["access_token"]

        # Return the access token in the URL fragment (#) rather than the query
        # string (?): fragments are not sent to the server, not stored in access
        # logs, and not included in Referer headers. The frontend reads it from
        # window.location.hash and clears it after use.
        fragment = f"token={quote(access_token, safe='')}"
        if redirect_to:
            fragment += f"&redirect_to={quote(redirect_to, safe='')}"
        frontend_url = f"{settings.OIDC_REDIRECT_BASE_URL}/auth/oidc/return#{fragment}"

        redirect = RedirectResponse(url=frontend_url, status_code=302)
        for header_name, header_value in token_response.raw_headers:
            if header_name.lower() == b"set-cookie":
                redirect.raw_headers.append((header_name, header_value))

        return redirect

    except HTTPException as e:
        # Map to friendly error codes the frontend can render. 503 (OIDC
        # disabled) still raises so API clients see it clearly.
        if e.status_code == status.HTTP_503_SERVICE_UNAVAILABLE:
            raise
        error_code = {
            status.HTTP_403_FORBIDDEN: "unverified",
            status.HTTP_401_UNAUTHORIZED: "session",
            status.HTTP_400_BAD_REQUEST: "invalid_response",
        }.get(e.status_code, "unknown")
        logger.info(f"OIDC callback failed ({e.status_code}): {e.detail}")
        return _login_error_redirect(error_code)
    except httpx.HTTPError as e:
        logger.warning(f"OIDC token/userinfo exchange failed: {e}")
        return _login_error_redirect("idp_unreachable")
    except Exception:
        logger.exception("Unhandled OIDC callback error")
        return _login_error_redirect("unknown")


@router.post(
    "/oidc/link",
    responses={
        400: {"description": "Account already linked"},
        401: {"description": "Not authenticated"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def start_oidc_link(
    response: Response,
    auth_data: CurrentUser,
    db: DbSession,
):
    _require_oidc()

    user = db.query(User).filter(User.id == auth_data.sub).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if user.authentik_sub:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Account is already linked to Authentik")

    state = secrets.token_urlsafe(32)
    oidc_nonce = secrets.token_urlsafe(32)
    await oauth.authentik.load_server_metadata()
    auth_url_data = await oauth.authentik.create_authorization_url(
        _link_callback_uri(), state=state, nonce=oidc_nonce,
    )

    link_response = RedirectResponse(url=auth_url_data["url"])
    _set_state_cookie(
        link_response,
        state,
        oidc_nonce=oidc_nonce,
        user_id=auth_data.sub,
        code_verifier=auth_url_data.get("code_verifier"),
    )
    return link_response


@router.get(
    "/oidc/link-callback",
    responses={
        401: {"description": "Invalid or expired state"},
        409: {"description": "Authentik account already linked to another user"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def oidc_link_callback(
    request: Request,
    response: Response,
    code: str,
    state: str,
    db: DbSession,
):
    _require_oidc()

    state_payload = _verify_and_pop_state_cookie(request, response, state)
    user_id = state_payload.get("u")
    if user_id is None:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid state: missing user context")
    code_verifier = state_payload.get("v")
    expected_nonce = state_payload.get("n")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if user.authentik_sub:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Account is already linked")

    try:
        token_endpoint, userinfo_endpoint = await _load_endpoints()
        userinfo, id_token = await _exchange_code(
            code, _link_callback_uri(), token_endpoint, userinfo_endpoint,
            code_verifier=code_verifier,
        )

        if not id_token:
            raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Missing ID token from identity provider")
        await _validate_id_token(
            id_token,
            expected_nonce=expected_nonce,
            expected_sub=userinfo.get("sub"),
        )

        authentik_sub = userinfo.get("sub")
        if not authentik_sub:
            raise HTTPException(status.HTTP_400_BAD_REQUEST, "Invalid OIDC response: missing sub")

        if not _is_email_verified(userinfo.get("email_verified")):
            raise HTTPException(
                status.HTTP_403_FORBIDDEN,
                "Authentik account email is not verified — verify your email before linking",
            )

        existing = db.query(User).filter(User.authentik_sub == authentik_sub).first()
        if existing:
            raise HTTPException(
                status.HTTP_409_CONFLICT,
                "This Authentik account is already linked to another user",
            )

        user.authentik_sub = authentik_sub
        db.commit()
        logger.info(f"Linked user {user.id} to Authentik sub {authentik_sub!r}")
        return {"status": "success", "message": "Account successfully linked to Authentik"}

    except HTTPException:
        raise
    except httpx.HTTPError as e:
        logger.exception(f"OIDC link-callback exchange failed: {e}")
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, "Identity provider unreachable")
    except Exception:
        logger.exception("Unhandled OIDC link-callback error")
        raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, "Account linking failed")
