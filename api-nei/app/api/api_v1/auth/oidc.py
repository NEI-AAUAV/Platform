"""
OIDC/OpenID Connect authentication endpoints for Authentik integration.

This module provides OAuth2/OIDC authentication flow to integrate with
the Authentik identity provider running in the infrastructure.
"""

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session
from authlib.integrations.starlette_client import OAuth, OAuthError
from loguru import logger
from typing import Optional

from app.api import deps
from app.core.config import settings
from app.models.user import User
from app.models.user.user_email import UserEmail
from app.schemas.user import UserCreate, ScopeEnum
from app import crud
from ._deps import Token, generate_response, verify_token, AuthData

router = APIRouter()

# Initialize OAuth client
oauth = OAuth()

if settings.OIDC_ENABLED:
    # For development: disable SSL verification if needed
    # In production, ensure proper SSL certificates are configured
    import httpx
    
    client_kwargs = {
        "scope": " ".join(settings.OIDC_SCOPES),
        "token_endpoint_auth_method": "client_secret_post",
    }
    
    # Disable SSL verification for development/self-signed certs
    if not settings.PRODUCTION:
        client_kwargs["verify"] = False
    
    oauth.register(
        name="authentik",
        client_id=settings.OIDC_CLIENT_ID,
        client_secret=settings.OIDC_CLIENT_SECRET,
        server_metadata_url=settings.OIDC_DISCOVERY_URL,
        client_kwargs=client_kwargs,
    )


def get_or_create_user_from_oidc(db: Session, userinfo: dict) -> User:
    """
    Get existing user or create new user from OIDC userinfo.

    This function handles both scenarios:
    1. User already exists with authentik_sub - return existing user
    2. User doesn't exist - create new user with data from Authentik

    **Parameters**
    * `db`: SQLAlchemy database session
    * `userinfo`: OIDC userinfo dict containing user claims

    **Returns**
    * User object
    """
    authentik_sub = userinfo.get("sub")
    email = userinfo.get("email")

    if not authentik_sub or not email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid OIDC response: missing sub or email",
        )

    # Try to find user by authentik_sub first
    user = db.query(User).filter(User.authentik_sub == authentik_sub).first()

    if user:
        logger.info(f"Found existing user with authentik_sub: {user.id}")
        return user

    # Try to find user by email (for account linking)
    user_email = db.query(UserEmail).filter(UserEmail.email == email).first()

    if user_email:
        # User exists but not linked to Authentik - link it now
        user = db.query(User).filter(User.id == user_email.user_id).first()
        if user:
            logger.info(f"Linking existing user {user.id} to Authentik sub: {authentik_sub}")
            user.authentik_sub = authentik_sub
            db.commit()
            db.refresh(user)
            return user

    # User doesn't exist - create new one
    logger.info(f"Creating new user from Authentik: {email}")

    # Extract user data from OIDC claims
    name_parts = userinfo.get("name", "").split(" ", 1)
    name = name_parts[0] if name_parts else userinfo.get("preferred_username", "User")
    surname = name_parts[1] if len(name_parts) > 1 else ""

    # Get NEI-specific attributes
    nmec = userinfo.get("nmec")
    iupi = userinfo.get("iupi")
    scopes_data = userinfo.get("scopes", ["DEFAULT"])

    # Parse scopes - could be a list or space-separated string
    if isinstance(scopes_data, str):
        scopes = scopes_data.split(" ")
    else:
        scopes = scopes_data if isinstance(scopes_data, list) else ["DEFAULT"]

    # Validate scopes against enum (normalize to lowercase first)
    valid_scopes = []
    for scope in scopes:
        try:
            # Normalize to lowercase for comparison
            normalized_scope = scope.strip().lower()
            valid_scopes.append(ScopeEnum(normalized_scope).value)
        except ValueError:
            logger.warning(f"Invalid scope from Authentik: {scope}, skipping")

    if not valid_scopes:
        valid_scopes = ["default"]

    # Create user object
    user_create = UserCreate(
        name=name[:20] if name else "User",  # Respect max length
        surname=surname[:20] if surname else "",
        email=email,
        password=None,  # No password for OIDC users
        scopes=valid_scopes,
        nmec=nmec,
        iupi=iupi,
    )

    # Create user in database
    user = crud.user.create(db=db, obj_in=user_create, active=True)

    # Link to Authentik
    user.authentik_sub = authentik_sub
    db.commit()
    db.refresh(user)

    logger.info(f"Created new user {user.id} from Authentik")
    return user


@router.get(
    "/oidc/login",
    responses={
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def oidc_login(request: Request, redirect_to: Optional[str] = None):
    """
    Initiate OIDC authentication flow.

    Redirects the user to Authentik for authentication.

    **Query Parameters**
    * `redirect_to`: Optional URL to redirect to after successful login

    **Returns**
    * Redirect response to Authentik authorization endpoint
    """
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="OIDC authentication is not enabled",
        )

    # Build callback URL
    callback_url = str(request.url_for("oidc_callback"))
    if redirect_to:
        callback_url = f"{callback_url}?redirect_to={redirect_to}"

    # Manually build authorization URL (avoiding session dependency)
    auth_url = await oauth.authentik.create_authorization_url(callback_url)
    
    return RedirectResponse(url=auth_url["url"])


@router.get(
    "/oidc/callback",
    response_model=Token,
    responses={
        401: {"description": "Authentication failed"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def oidc_callback(
    request: Request,
    code: str,
    state: Optional[str] = None,
    db: Session = Depends(deps.get_db),
    redirect_to: Optional[str] = None,
):
    """
    Handle OIDC callback from Authentik.

    Exchanges authorization code for tokens, retrieves user info,
    and creates/updates user in the platform database.

    **Query Parameters**
    * `code`: Authorization code from Authentik (automatic)
    * `state`: State parameter for CSRF protection (automatic)
    * `redirect_to`: Optional URL to redirect to after login

    **Returns**
    * Token response with access_token and refresh cookie
    """
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="OIDC authentication is not enabled",
        )

    try:
        # Load server metadata if not already loaded
        await oauth.authentik.load_server_metadata()
        
        # Manually exchange code for token using httpx
        token_endpoint = oauth.authentik.server_metadata["token_endpoint"]
        
        # Use same SSL verification setting as OAuth client
        verify_ssl = settings.PRODUCTION
        
        async with httpx.AsyncClient(verify=verify_ssl) as client:
            # Exchange authorization code for tokens
            token_response = await client.post(
                token_endpoint,
                data={
                    "grant_type": "authorization_code",
                    "code": code,
                    "redirect_uri": str(request.url_for("oidc_callback")),
                    "client_id": settings.OIDC_CLIENT_ID,
                    "client_secret": settings.OIDC_CLIENT_SECRET,
                },
            )
            token_response.raise_for_status()
            token = token_response.json()

            # Get user information from userinfo endpoint
            userinfo_endpoint = oauth.authentik.server_metadata["userinfo_endpoint"]
            userinfo_response = await client.get(
                userinfo_endpoint,
                headers={"Authorization": f"Bearer {token['access_token']}"},
            )
            userinfo_response.raise_for_status()
            userinfo = userinfo_response.json()

        logger.debug(f"OIDC userinfo: {userinfo}")

        # Create or get user from OIDC data
        user = get_or_create_user_from_oidc(db, userinfo)

        # Generate platform JWT tokens using existing infrastructure
        response = generate_response(db, user)

        # If redirect_to provided, could handle redirect here
        # For API, we just return the tokens
        return response

    except OAuthError as e:
        logger.error(f"OAuth error during OIDC callback: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication failed: {str(e)}",
        )
    except Exception as e:
        logger.error(f"Unexpected error during OIDC callback: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Authentication failed due to server error",
        )


@router.post(
    "/oidc/link",
    responses={
        401: {"description": "Not authenticated"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def start_oidc_link(
    request: Request,
    auth_data: AuthData = Depends(verify_token),
    db: Session = Depends(deps.get_db),
):
    """
    Start account linking flow for existing users.

    Allows users who registered with password to link their account
    to Authentik for SSO access.

    **Returns**
    * Redirect URL to Authentik for account linking
    """
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="OIDC authentication is not enabled",
        )

    # Get current user from auth_data
    user = db.query(User).filter(User.id == auth_data.user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    if user.authentik_sub:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Account is already linked to Authentik",
        )

    # Create state token containing user_id for verification in callback
    # Note: In production, this should be a signed JWT or stored in Redis
    state = f"link:{user.id}"

    callback_url = request.url_for("oidc_link_callback")
    callback_url = f"{callback_url}?state={state}"

    return await oauth.authentik.authorize_redirect(request, callback_url)


@router.get(
    "/oidc/link-callback",
    responses={
        401: {"description": "Invalid state or authentication failed"},
        503: {"description": "OIDC authentication is disabled"},
    },
)
async def oidc_link_callback(
    request: Request,
    state: str,
    db: Session = Depends(deps.get_db),
):
    """
    Complete account linking flow.

    Links an existing platform user account to their Authentik identity.

    **Query Parameters**
    * `state`: State token containing user_id (automatic)
    * `code`: Authorization code from Authentik (automatic)

    **Returns**
    * Success message
    """
    if not settings.OIDC_ENABLED:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="OIDC authentication is not enabled",
        )

    # Verify state and extract user_id
    if not state.startswith("link:"):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid state parameter",
        )

    try:
        user_id = int(state.split(":")[1])
    except (IndexError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid state parameter",
        )

    # Get user
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    if user.authentik_sub:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Account is already linked",
        )

    try:
        # Exchange authorization code for tokens
        token = await oauth.authentik.authorize_access_token(request)
        userinfo = token.get("userinfo") or await oauth.authentik.userinfo(token=token)

        authentik_sub = userinfo.get("sub")
        if not authentik_sub:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid OIDC response",
            )

        # Check if this Authentik account is already linked to another user
        existing = db.query(User).filter(User.authentik_sub == authentik_sub).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="This Authentik account is already linked to another user",
            )

        # Link the accounts
        user.authentik_sub = authentik_sub
        db.commit()

        logger.info(f"Successfully linked user {user.id} to Authentik sub: {authentik_sub}")

        return {
            "status": "success",
            "message": "Account successfully linked to Authentik",
        }

    except OAuthError as e:
        logger.error(f"OAuth error during account linking: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication failed: {str(e)}",
        )
