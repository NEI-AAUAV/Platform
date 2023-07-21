from fastapi import APIRouter, Depends, HTTPException, Cookie, Response, status

from loguru import logger
from sqlalchemy.orm import Session
from jose import JWTError
from datetime import datetime

from app import crud
from app.api import deps
from app.models.device_login import DeviceLogin

from ._deps import (
    Token,
    generate_response,
    decode_token,
    REFRESH_TOKEN_TYPE,
    VERIFICATION_TOKEN_TYPE,
    OperationSuccessfulResponse,
)

router = APIRouter()


def _validate_refresh_token(db, token):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Refresh"},
    )

    if token is None:
        raise credentials_exception

    try:
        payload = decode_token(token)
        # Extract all needed fields inside a `try` in case a token
        # has a bad payload.
        user_id = int(payload["sub"])
        session_id = int(payload["sid"])
        issued_at = payload["iat"]
        token_type = payload["type"]
    except (JWTError, ValueError, KeyError):
        raise credentials_exception

    # Check that the token is a refresh token
    if token_type != REFRESH_TOKEN_TYPE:
        raise credentials_exception

    # Get the token's session from the database
    device_login = db.query(DeviceLogin).get((user_id, session_id))
    if device_login is None:
        raise credentials_exception

    # Safety check that the session hasn't expired, the token should already
    # encode this.
    if device_login.expires_at < datetime.now():
        logger.warning(f"Token that should be expired was accepted")
        # Remove the device login from the database since it's no longer used
        db.delete(device_login)
        db.commit()

        raise credentials_exception

    # Check that this token issue date isn't before the last token refresh, if
    # this happens it might mean someone got the token and is trying to replay it
    if int(device_login.refreshed_at.timestamp()) > issued_at:
        logger.warning(f"A refresh token was resubmitted")
        # Preemptively remove the device login in order to prevent the token
        # from being used by a malicious third party.
        db.delete(device_login)
        db.commit()

        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        # The user no longer exists so the device login is no longer useful.
        db.delete(device_login)
        db.commit()

        raise credentials_exception

    return user, device_login


@router.post(
    "/refresh",
    responses={401: {"description": "Invalid refresh token"}},
    response_model=Token,
)
async def refresh(
    db: Session = Depends(deps.get_db), refresh: str | None = Cookie(default=None)
):
    user, device_login = _validate_refresh_token(db, refresh)
    return generate_response(db, user, device_login)


@router.get(
    "/verify",
    responses={401: {"description": "Invalid confirmation token"}},
    response_model=OperationSuccessfulResponse,
)
async def verify(
    token: str,
    db: Session = Depends(deps.get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid confirmation token",
        headers={"WWW-Authenticate": "Verify"},
    )

    try:
        payload = decode_token(token)
        # Extract all needed fields inside a `try` in case a token
        # has a bad payload.
        user_id = int(payload["sub"])
        email = payload["email"]
        token_type = payload["type"]
    except (JWTError, ValueError, KeyError):
        raise credentials_exception

    # Check that the token is a verification token
    if token_type != VERIFICATION_TOKEN_TYPE:
        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception

    crud.user.activate_email(db, user=user, email=email)

    return OperationSuccessfulResponse(
        status="success", message="Account verified successfully"
    )


@router.post(
    "/logout",
    responses={401: {"description": "Invalid refresh token"}},
    response_model=OperationSuccessfulResponse,
)
async def logout(
    response: Response,
    db: Session = Depends(deps.get_db),
    refresh: str | None = Cookie(default=None),
):
    # remove the refresh token cookie from the client
    response.delete_cookie("refresh")

    _, device_login = _validate_refresh_token(db, refresh)

    # invalidate the user's token and clear it from the server-side
    db.delete(device_login)
    db.commit()

    return OperationSuccessfulResponse(
        status="success", message="You have been logged out."
    )
