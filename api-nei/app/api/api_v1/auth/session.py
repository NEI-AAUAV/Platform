from fastapi import APIRouter, Depends, HTTPException, Cookie, status

from sqlalchemy.orm import Session
from pydantic import BaseModel
from jose import JWTError
from datetime import datetime
from typing import Literal

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


@router.post(
    "/refresh",
    responses={401: {"description": "Invalid refresh token"}},
    response_model=Token,
)
async def refresh(
    db: Session = Depends(deps.get_db), refresh: str | None = Cookie(default=None)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Refresh"},
    )

    if refresh is None:
        raise credentials_exception

    try:
        payload = decode_token(refresh)
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
        raise credentials_exception

    # Check that this token issue date isn't before the last token refresh, if
    # this happens it might mean someone got the token and is trying to replay it
    if int(device_login.refreshed_at.timestamp()) > issued_at:
        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception

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
        token_type = payload["type"]
    except (JWTError, ValueError, KeyError):
        raise credentials_exception

    # Check that the token is a verification token
    if token_type != VERIFICATION_TOKEN_TYPE:
        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception

    crud.user.update(db, db_obj=user, obj_in={"active": True})

    return OperationSuccessfulResponse(
        status="success", message="Account verified successfully"
    )