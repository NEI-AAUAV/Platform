from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm

from typing import Literal
from sqlalchemy.orm import Session
from email_validator import validate_email, EmailNotValidError

from app import crud
from app.api import deps
from app.models.user import User

from ._deps import Token, generate_response, pwd_context

router = APIRouter()


def _authenticate_user(db: Session, email: str, password: str) -> User | Literal[False]:
    """Attempts to login as an user by email and verifying the password

    **Parameters**
    * `db`: A SQLAlchemy ORM session
    * `email`: The user's email address
    * `password`: The user's password

    **Returns**
    The User information if the login was successful otherwise False
    """
    maybe_user = crud.user.get_by_email(db, email)
    if maybe_user is None:
        return False

    user, _ = maybe_user

    if not pwd_context.verify(password, user.hashed_password):
        return False

    if pwd_context.needs_update(user.hashed_password):
        new_hash = pwd_context.hash(password)
        crud.user.update(db, db_obj=user, obj_in={"hashed_password": new_hash})

    return user


@router.post(
    "/login",
    response_model=Token,
    responses={401: {"description": "Incorrect username or password"}},
)
async def login(
    db: Session = Depends(deps.get_db), form_data: OAuth2PasswordRequestForm = Depends()
):
    try:
        # OAuth2 requires the password flow field to be named 'username' even though
        # it's going to have an email.
        #
        # https://fastapi.tiangolo.com/tutorial/security/simple-oauth2/#get-the-username-and-password
        validation = validate_email(
            form_data.username,
            check_deliverability=False,
            dns_resolver=deps.email_resolver,
        )
        email = validation.normalized
    except EmailNotValidError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is invalid",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = _authenticate_user(db, email, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return generate_response(db, user)
