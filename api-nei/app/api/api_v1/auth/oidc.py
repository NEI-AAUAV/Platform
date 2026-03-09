"""
OIDC/OpenID Connect authentication endpoints for Authentik integration.

Flow
----
Login:
  1. GET /auth/oidc/login  →  redirect to Authentik with a signed state cookie
  2. GET /auth/oidc/callback  →  verify state, exchange code, upsert user, return platform JWT

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

Authentik property-mapping requirements
----------------------------------------
The userinfo endpoint must expose these custom claims (configure via
Authentik → Customisation → Property Mappings → Scope Mappings):

  Scope: nei_nmec
    Expression:  return {"nmec": request.user.attributes.get("nmec")}

  Scope: nei_iupi
    Expression:  return {"iupi": request.user.attributes.get("iupi")}

  Scope: nei_scopes
    Expression:  return {"scopes": request.user.attributes.get("platform_scopes", ["default"])}

These scopes must be added to the nei-platform Application → Protocol Settings.
"""

import secrets
from typing import Optional

import httpx
from authlib.integrations.starlette_client import OAuth
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

router = APIRouter()


# ---------------------------------------------------------------------------
# OAuth client setup
# ---------------------------------------------------------------------------

oauth = OAuth()

if settings.OIDC_ENABLED:
    client_kwargs: dict = {
        "scope": " ".join(settings.OIDC_SCOPES),
        "token_endpoint_auth_method": "client_secret_post",
    }
    if not settings.PRODUCTION:
        # Allow self-signed certs in development
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
_STATE_MAX_AGE = 600  # 10 minutes — plenty for the Authentik round-trip


def _signer() -> URLSafeTimedSerializer:
    # Reuse the JWT private key as the HMAC secret — already confidential,
    # available on startup, consistent across restarts and replicas.
    return URLSafeTimedSerializer(private_key)


def _set_state_cookie(
    response: Response,
    nonce: str,
    *,
    redirect_to: Optional[str] = None,
    user_id: Optional[int] = None,
) -> None:
    """Sign and store OAuth state in an HttpOnly cookie."""
    payload: dict = {"n": nonce}
    if redirect_to:
        payload["r"] = redirect_to
    if user_id is not None:
        payload["u"] = user_id
    response.set_cookie(
        _STATE_COOKIE,
        _signer().dumps(payload),
        httponly=True,
        secure=settings.PRODUCTION,
        samesite="lax",
        max_age=_STATE_MAX_AGE,
    )


def _verify_and_pop_state_cookie(request: Request, response: Response, nonce: str) -> dict:
    """Read, verify and clear the state cookie.  Raises 401 on any failure."""
    cookie_val = request.cookies.get(_STATE_COOKIE)
    # Always clear the cookie regardless of outcome (prevent replay)
    response.delete_cookie(_STATE_COOKIE, httponly=True, samesite="lax")

    if not cookie_val:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Missing OAuth state cookie")

    try:
        payload = _signer().loads(cookie_val, max_age=_STATE_MAX_AGE)
    except SignatureExpired:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "OAuth state expired — please try again")
    except BadSignature:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid OAuth state")

    if payload.get("n") != nonce:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "OAuth state mismatch")

    return payload


# ---------------------------------------------------------------------------
# Authentik metadata / token exchange helpers
# ---------------------------------------------------------------------------

async def _load_endpoints() -> tuple[str, str]:
    """Return (token_endpoint, userinfo_endpoint) from Authentik discovery."""
    meta = await oauth.authentik.load_server_metadata()
    return meta["token_endpoint"], meta["userinfo_endpoint"]


async def _exchange_code(
    code: str,
    redirect_uri: str,
    token_endpoint: str,
    userinfo_endpoint: str,
) -> dict:
    """Exchange an authorization code for userinfo.  Returns the userinfo dict."""
    verify_ssl = settings.PRODUCTION
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        token_resp = await client.post(
            token_endpoint,
            data={
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": redirect_uri,
                "client_id": settings.OIDC_CLIENT_ID,
                "client_secret": settings.OIDC_CLIENT_SECRET,
            },
        )
        token_resp.raise_for_status()
        token = token_resp.json()

        userinfo_resp = await client.get(
            userinfo_endpoint,
            headers={"Authorization": f"Bearer {token['access_token']}"},
        )
        userinfo_resp.raise_for_status()
        return userinfo_resp.json()


# ---------------------------------------------------------------------------
# User upsert
# ---------------------------------------------------------------------------

def _parse_scopes(raw) -> list[str]:
    """Normalise scopes from an OIDC claim (list or space-separated string)."""
    if isinstance(raw, str):
        items = raw.split()
    elif isinstance(raw, list):
        items = raw
    else:
        return ["default"]

    valid = []
    for s in items:
        try:
            valid.append(ScopeEnum(s.strip().lower()).value)
        except ValueError:
            logger.warning(f"Unknown scope from Authentik: {s!r} — skipping")
    return valid or ["default"]


def get_or_create_user_from_oidc(db: Session, userinfo: dict) -> User:
    """Get or create a platform user from Authentik userinfo, syncing data on every login.

    Lookup order:
      1. By authentik_sub  — fast path for already-linked users
      2. By email          — auto-link accounts created during the migration

    On every login, name / surname / nmec / iupi / scopes are synced from
    Authentik so the platform DB stays consistent with Authentik as the IdP.
    """
    authentik_sub = userinfo.get("sub")
    email = userinfo.get("email")

    if not authentik_sub or not email:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Invalid OIDC response: missing sub or email",
        )

    # Parse claims
    name_parts = userinfo.get("name", "").split(" ", 1)
    name = (name_parts[0] or "").strip()[:20] or "User"
    surname = (name_parts[1] if len(name_parts) > 1 else "").strip()[:20]
    nmec: Optional[int] = userinfo.get("nmec")
    iupi: Optional[str] = userinfo.get("iupi")
    scopes = _parse_scopes(userinfo.get("scopes", []))

    # 1. Look up by authentik_sub
    user: Optional[User] = db.query(User).filter(User.authentik_sub == authentik_sub).first()

    if not user:
        # 2. Look up by email — covers migrated users who haven't logged in via OIDC yet
        email_row = db.query(UserEmail).filter(UserEmail.email == email).first()
        if email_row:
            user = db.query(User).filter(User.id == email_row.user_id).first()
            if user:
                logger.info(f"Auto-linking user {user.id} to Authentik sub {authentik_sub!r}")

    if user:
        # Sync mutable fields — Authentik is the source of truth after migration
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

        logger.info(f"OIDC login: user {user.id} ({'synced' if changed else 'unchanged'})")
        return user

    # 3. New user — create from OIDC data
    logger.info(f"Creating new user from Authentik: {email!r}")
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


# ---------------------------------------------------------------------------
# Guard
# ---------------------------------------------------------------------------

def _require_oidc() -> None:
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE,
            "OIDC authentication is not enabled",
        )


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------

@router.get(
    "/oidc/login",
    responses={503: {"description": "OIDC authentication is disabled"}},
)
async def oidc_login(
    request: Request,
    response: Response,
    redirect_to: Optional[str] = None,
):
    """Initiate OIDC login: redirect to Authentik.

    **Query Parameters**
    * `redirect_to`: Optional URL the frontend should navigate to after login
      (returned in the callback JSON so the client can act on it).
    """
    _require_oidc()

    nonce = secrets.token_urlsafe(32)
    redirect_uri = str(request.url_for("oidc_callback"))
    await oauth.authentik.load_server_metadata()
    auth_url_data = await oauth.authentik.create_authorization_url(redirect_uri, state=nonce)
    auth_url = auth_url_data["url"]

    redirect_response = RedirectResponse(url=auth_url)
    _set_state_cookie(redirect_response, nonce, redirect_to=redirect_to)
    return redirect_response


@router.get(
    "/oidc/callback",
    response_model=Token,
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
    db: Session = Depends(deps.get_db),
):
    """Handle Authentik callback: verify state, exchange code, return platform tokens.

    On success the response body is `{access_token, token_type}` (same as
    password login).  If `redirect_to` was passed to `/oidc/login`, it is
    included in the response as `redirect_to` so the frontend can navigate.
    """
    _require_oidc()

    state_payload = _verify_and_pop_state_cookie(request, response, state)
    redirect_to: Optional[str] = state_payload.get("r")

    try:
        token_endpoint, userinfo_endpoint = await _load_endpoints()
        redirect_uri = str(request.url_for("oidc_callback"))
        userinfo = await _exchange_code(code, redirect_uri, token_endpoint, userinfo_endpoint)
        logger.debug(f"OIDC userinfo: {userinfo}")

        user = get_or_create_user_from_oidc(db, userinfo)
        token_response = generate_response(db, user)

        if redirect_to:
            # Surface redirect_to so the frontend SPA can navigate after it
            # receives and stores the token.
            token_response.headers["X-Redirect-To"] = redirect_to

        return token_response

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"OIDC callback error: {e}")
        raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, "Authentication failed")


@router.post(
    "/oidc/link",
    responses={
        400: {"description": "Account already linked"},
        401: {"description": "Not authenticated"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def start_oidc_link(
    request: Request,
    auth_data: AuthData = Depends(verify_token),
    db: Session = Depends(deps.get_db),
):
    """Start account linking: redirect authenticated user to Authentik.

    Allows users who registered with a password to link their account to
    Authentik so they can use SSO in the future.
    """
    _require_oidc()

    user = db.query(User).filter(User.id == auth_data.sub).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if user.authentik_sub:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Account is already linked to Authentik")

    nonce = secrets.token_urlsafe(32)
    redirect_uri = str(request.url_for("oidc_link_callback"))
    await oauth.authentik.load_server_metadata()
    auth_url_data = await oauth.authentik.create_authorization_url(redirect_uri, state=nonce)
    auth_url = auth_url_data["url"]

    link_response = RedirectResponse(url=auth_url)
    _set_state_cookie(link_response, nonce, user_id=auth_data.sub)
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
    db: Session = Depends(deps.get_db),
):
    """Complete account linking."""
    _require_oidc()

    state_payload = _verify_and_pop_state_cookie(request, response, state)
    user_id = state_payload.get("u")
    if user_id is None:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid state: missing user context")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if user.authentik_sub:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Account is already linked")

    try:
        token_endpoint, userinfo_endpoint = await _load_endpoints()
        redirect_uri = str(request.url_for("oidc_link_callback"))
        userinfo = await _exchange_code(code, redirect_uri, token_endpoint, userinfo_endpoint)

        authentik_sub = userinfo.get("sub")
        if not authentik_sub:
            raise HTTPException(status.HTTP_400_BAD_REQUEST, "Invalid OIDC response: missing sub")

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
    except Exception as e:
        logger.error(f"OIDC link-callback error: {e}")
        raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, "Account linking failed")
