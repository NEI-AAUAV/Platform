from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Form,
    BackgroundTasks,
    status,
)

from jose import JWTError
from datetime import datetime
from pydantic import SecretStr
from sqlalchemy.orm import Session
from email_validator import validate_email, EmailNotValidError

from app import crud
from app.api import deps, email as emailUtils
from app.core.config import settings

from ._deps import (
    resolver,
    create_token,
    decode_token,
    hash_password,
    PASSWORD_RESET_TOKEN_TYPE,
    OperationSuccessfulResponse,
)

router = APIRouter()


def _create_password_reset_token(uid: int) -> str:
    """Generates a password reset token

    **Parameters**
    * `uid`: The id of the user

    **Returns**
    The generated password reset token
    """
    iat = datetime.now()
    return create_token(
        {
            "iat": iat,
            "exp": iat + settings.PASSWORD_RESET_TOKEN_EXPIRE,
            # JWT requires 'sub' to be a string
            "sub": str(uid),
            "type": PASSWORD_RESET_TOKEN_TYPE,
        },
    )


async def _send_password_reset_token(email: str, name: str, uid: int):
    """Generates a password reset token and emails it

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `uid`: The id of the user
    """
    confirmation_token = _create_password_reset_token(uid)
    await emailUtils.send_password_reset(email, name, confirmation_token)


@router.post(
    "/forgot",
    responses={
        404: {"description": "The provided email is not associated with an user"},
        503: {"description": "Password resets are not enabled"},
    },
    response_model=OperationSuccessfulResponse,
)
async def forgot(
    background_tasks: BackgroundTasks,
    email: str = Form(),
    db: Session = Depends(deps.get_db),
):
    try:
        validation = validate_email(
            email,
            check_deliverability=False,
            dns_resolver=resolver,
        )
        email = validation.email
    except EmailNotValidError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is invalid",
        )

    user = crud.user.get_by_email(db, email)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="The provided email is not associated with an user",
        )

    if settings.EMAIL_ENABLED:
        # Schedule to send the email with password reset link
        background_tasks.add_task(_send_password_reset_token, email, user.name, user.id)
    else:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Password resets are not enabled",
        )

    return OperationSuccessfulResponse(
        status="success", message="Password reset email sent successfully"
    )


@router.post(
    "/reset",
    responses={401: {"description": "Invalid authentication token"}},
    response_model=OperationSuccessfulResponse,
)
async def reset(
    background_tasks: BackgroundTasks,
    token: str,
    password: SecretStr = Form(),
    db: Session = Depends(deps.get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid confirmation token",
        headers={"WWW-Authenticate": "Reset"},
    )

    try:
        payload = decode_token(token)
        # Extract all needed fields inside a `try` in case a token
        # has a bad payload.
        user_id = int(payload["sub"])
        token_type = payload["type"]
    except (JWTError, ValueError, KeyError):
        raise credentials_exception

    # Check that the token is a password reset token token
    if token_type != PASSWORD_RESET_TOKEN_TYPE:
        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception

    # Update the user's password
    crud.user.update(
        db,
        db_obj=user,
        obj_in={"hashed_password": hash_password(password.get_secret_value())},
    )

    if settings.EMAIL_ENABLED:
        # Schedule to send the email with a warning that the password was changed
        background_tasks.add_task(
            emailUtils.send_password_changed, user.email, user.name
        )

    return OperationSuccessfulResponse(
        status="success", message="Password reset successfully"
    )