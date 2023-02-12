from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from pydantic import BaseModel, SecretStr, validator, AnyStrMinLengthError
from jose import JWTError, jwt
from datetime import datetime
from typing import Literal

from app import crud
from app.api import deps
from app.models.user import User
from app.schemas.user import UserBase, UserCreate
from app.core.config import settings

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=settings.API_V1_STR + "/auth/login")

if settings.JWT_SECRET_KEY is None:
    raise Exception("No JWT secret provided")

pwd_context = CryptContext(
    # Algoritmos aceites para a verificação das password hashed.
    #
    # O primeiro algoritmo da lista será usado para calcular a hash das passwords novas.
    #
    # NOTA: Eu não sou perito da coisa mas esta era a recomendação mais alta ¯\_(ツ)_/¯
    # https://passlib.readthedocs.io/en/stable/narr/quickstart.html#recommended-hashes
    # https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
    schemes=["argon2"],
    # Esta opção marca todas as hash de passwords que usam algoritmos que não o primeiro
    # no `schemes` como precisando de migração para o novo algoritmo
    deprecated="auto",
    # Alguns algoritmos têm um tamanho limite nas passwords e truncam as passwords
    # maiores que esse limite. Isso é bastante mau de um ponto de vista de segurança
    # então deve retornar-se um erro em vez de as truncar.
    #
    # https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#input-limits
    # https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html#implement-proper-password-strength-controls
    truncate_error=True,
)


class Token(BaseModel):
    """Authentication data"""

    access_token: str
    token_type: str


def hash_password(password: str) -> str:
    """Calculates the password hash

    **Parameters**
    * `password`: The plaintext password

    **Returns**
    The hashed password as a string
    """
    return pwd_context.hash(password)


def authenticate_user(db: Session, email: str, password: str) -> User | Literal[False]:
    """Attempts to login as an user by email and verifying the password

    **Parameters**
    * `db`: A SQLAlchemy ORM session
    * `email`: The user's email address
    * `password`: The user's password

    **Returns**
    The User information if the login was successful otherwise False
    """
    user = crud.user.get_by_email(db, email)
    if user is None:
        return False
    if not pwd_context.verify(password, user.hashed_password):
        return False
    if pwd_context.needs_update(user.hashed_password):
        new_hash = pwd_context.hash(password)
        crud.user.update(db, db_obj=user, obj_in={"hashed_password": new_hash})
    return user


def create_access_token(user: User) -> str:
    """Creates a new access token for a user

    **Parameters**
    * `user`: The user's information

    **Returns**
    A JWT encoded access token for the user
    """
    expire = datetime.utcnow() + settings.ACCESS_TOKEN_EXPIRE
    encoded_jwt = jwt.encode(
        # JWT requires 'sub' to be a string
        {
            "sub": str(user.id),
            "nmec": user.nmec,
            "name": user.name,
            "surname": user.surname,
            "scopes": user.scopes,
            "exp": expire,
        },
        settings.JWT_SECRET_KEY,
        algorithm=settings.JWT_ALGORITHM,
    )
    return encoded_jwt


async def get_current_user(
    db: Session = Depends(deps.get_db), token: str = Depends(oauth2_scheme)
) -> User:
    """Dependency for user authentication"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM],
        )
        user_id_str: str | None = payload.get("sub")
        if user_id_str is None:
            raise credentials_exception
        user_id: int = int(user_id_str)
    except (JWTError, ValueError):
        raise credentials_exception
    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception
    return user


@router.post(
    "/login",
    response_model=Token,
    responses={401: {"description": "Incorrect username or password"}},
)
async def login(
    db: Session = Depends(deps.get_db), form_data: OAuth2PasswordRequestForm = Depends()
):
    # OAuth2 requires the password flow field to be named 'username' even though
    # it's going to have an email.
    #
    # https://fastapi.tiangolo.com/tutorial/security/simple-oauth2/#get-the-username-and-password
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(user)
    return Token(access_token=access_token, token_type="bearer")


class UserRegisterForm(UserBase):
    """Properties to receive via API on register."""

    email: str
    password: SecretStr

    @validator("password")
    def has_min_length(cls, v):
        min_length = 8
        if len(v.get_secret_value()) < min_length:
            raise AnyStrMinLengthError(limit_value=min_length)
        return v


@router.post(
    "/register",
    response_model=Token,
    responses={409: {"description": "Email already exists"}},
)
async def register(
    form_data: UserRegisterForm,
    db: Session = Depends(deps.get_db),
):
    user_exists = crud.user.get_by_email(db, form_data.email)
    if user_exists is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already exists",
            headers={"WWW-Authenticate": "Bearer"},
        )
    create_user = UserCreate(
        **form_data.dict(),
        hashed_password=hash_password(form_data.password.get_secret_value())
    )
    user = crud.user.create(db, obj_in=create_user)
    access_token = create_access_token(user)
    return Token(access_token=access_token, token_type="bearer")
