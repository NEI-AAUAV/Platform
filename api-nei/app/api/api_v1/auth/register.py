from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks

from typing import Optional
from datetime import datetime
from sqlalchemy.orm import Session
from pydantic import SecretStr, validator, AnyStrMinLengthError, MissingError
from email_validator import validate_email, EmailNotValidError

from app import crud
from app.api import deps, email as emailUtils
from app.api.recaptcha import verify_reCaptcha
from app.schemas.user import UserBase, UserCreate
from app.core.config import settings

from ._deps import (
    Token,
    resolver,
    hash_password,
    generate_response,
    create_token,
    VERIFICATION_TOKEN_TYPE,
)

router = APIRouter()


def _create_email_verification_token(uid: int) -> str:
    """Generates a verification token

    **Parameters**
    * `uid`: The id of the user

    **Returns**
    The generated email verification token
    """
    iat = datetime.now()
    return create_token(
        {
            "iat": iat,
            "exp": iat + settings.CONFIRMATION_TOKEN_EXPIRE,
            # JWT requires 'sub' to be a string
            "sub": str(uid),
            "type": VERIFICATION_TOKEN_TYPE,
        },
    )


async def _send_verification_token(email: str, name: str, uid: int):
    """Generates a verification token and emails it

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `uid`: The id of the user
    """
    confirmation_token = _create_email_verification_token(uid)
    await emailUtils.send_email_confirmation(email, name, confirmation_token)


class UserRegisterForm(UserBase):
    """Properties to receive via API on register."""

    email: str
    password: SecretStr
    recaptcha_token: Optional[str]

    @validator("password")
    def has_min_length(cls, v):
        min_length = 8
        if len(v.get_secret_value()) < min_length:
            raise AnyStrMinLengthError(limit_value=min_length)
        return v

    @validator("recaptcha_token")
    def has_recaptcha_token(cls, v):
        if v is None and settings.RECAPTCHA_ENABLED:
            raise MissingError
        return v


@router.post(
    "/register",
    response_model=Token,
    responses={409: {"description": "Email already exists"}},
)
async def register(
    form_data: UserRegisterForm,
    background_tasks: BackgroundTasks,
    db: Session = Depends(deps.get_db),
):
    score = await verify_reCaptcha(form_data.recaptcha_token)

    if score < settings.RECAPTCHA_REGISTER_THRESHOLD:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Slow down",
            headers={"WWW-Authenticate": "reCaptcha"},
        )

    try:
        validation = validate_email(
            form_data.email,
            check_deliverability=settings.PRODUCTION,
            dns_resolver=resolver,
        )
        email = validation.email
    except EmailNotValidError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is invalid",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = crud.user.get_by_email(db, email)
    if user is not None and (
        # Check that the user is active or the account was created less than a day ago
        user.active
        or (datetime.utcnow() - user.created_at) < settings.CONFIRMATION_TOKEN_EXPIRE
    ):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already exists",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if user is not None:
        # If the user existed make sure it's properly deleted, this will also
        # make sure that other tables referencing this user are also scrubed
        # like for example the logins table.
        crud.user.remove(db, id=user.id)
    create_user = UserCreate(
        **form_data.dict(),
        active=not settings.EMAIL_ENABLED,
        hashed_password=hash_password(form_data.password.get_secret_value()),
    )
    user = crud.user.create(db, obj_in=create_user)

    if settings.EMAIL_ENABLED:
        # Schedule to send the email with confirmation link
        background_tasks.add_task(
            _send_verification_token, email, form_data.name, user.id
        )
    return generate_response(db, user)