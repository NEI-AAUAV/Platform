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
from loguru import logger
from pydantic import SecretStr
from sqlalchemy.orm import Session

from app import crud
from app.api import deps, email as emailUtils
from app.core.config import settings
from app.models.user.user import User

from ._deps import (
    create_token,
    decode_token,
    hash_password,
    MAGIC_LINK_TOKEN_TYPE,
    OperationSuccessfulResponse,
)

router = APIRouter()


def _create_magic_link_token(uid: int, email: str) -> str:
    """Generates a magic link token

    **Parameters**
    * `uid`: The id of the user
    * `email`: The email the user

    **Returns**
    The generated magic link token
    """
    iat = datetime.now()
    return create_token(
        {
            "iat": iat,
            "exp": iat + settings.MAGIC_LINK_TOKEN_EXPIRE,
            # JWT requires 'sub' to be a string
            "sub": str(uid),
            "email": email,
            "type": MAGIC_LINK_TOKEN_TYPE,
        },
    )


async def _send_magic_link_token(email: str, name: str, uid: int, reason: str):
    """Generates a magic link and emails it

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `uid`: The id of the user
    """
    magic_link_token = _create_magic_link_token(uid, email)
    await emailUtils.send_magic_link(email, name, reason, magic_link_token)


def send_magic_link(
    user: User,
    email: str,
    background_tasks: BackgroundTasks,
    reason: str,
):
    if settings.EMAIL_ENABLED:
        # Schedule to send the email with password reset link
        background_tasks.add_task(
            _send_magic_link_token, email, user.name, user.id, reason
        )
    else:
        logger.error(f"Email is disabled, couldn't send magic link for {email}")


@router.post(
    "/magic",
    responses={401: {"description": "Invalid token"}},
    response_model=OperationSuccessfulResponse,
)
async def activate_magic_link(
    background_tasks: BackgroundTasks,
    token: str,
    password: SecretStr = Form(),
    db: Session = Depends(deps.get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid token",
        headers={"WWW-Authenticate": "Reset"},
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

    # Check that the token is a magic link token
    if token_type != MAGIC_LINK_TOKEN_TYPE:
        raise credentials_exception

    with db.begin_nested():
        maybe_user = crud.user.get_email_fq(
            db, id=user_id, email=email, for_update=True
        )
        if maybe_user is None:
            raise credentials_exception

        (user, user_email) = maybe_user

        if user_email.active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email is already active",
            )

        # Update the user's password
        user.hashed_password = hash_password(password.get_secret_value())
        # Activate the user email
        user_email.active = True
        db.commit()

    if settings.EMAIL_ENABLED:
        # Schedule to send the email with a warning that the password was changed
        background_tasks.add_task(emailUtils.send_password_changed, email, user.name)

    return OperationSuccessfulResponse(
        status="success", message="Password set successfully"
    )
