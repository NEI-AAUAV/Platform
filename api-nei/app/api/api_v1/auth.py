from fastapi import APIRouter, Depends, HTTPException, Cookie, status, BackgroundTasks
from fastapi.security import (
    OAuth2PasswordBearer,
    OAuth2PasswordRequestForm,
    SecurityScopes,
)
from fastapi.responses import JSONResponse, Response

from sqlalchemy.orm import Session
from passlib.context import CryptContext
from pydantic import (
    BaseModel,
    SecretStr,
    validator,
    AnyStrMinLengthError,
    BaseModel,
)
from jose import JWTError, jwt
from datetime import datetime, timedelta
from typing import Literal, Any
from email_validator import validate_email, caching_resolver, EmailNotValidError

from app import crud
from app.api import deps, email as emailUtils
from app.models.user import User
from app.models.device_login import DeviceLogin
from app.schemas.user import UserBase, UserCreate, ScopeEnum
from app.core.config import settings

router = APIRouter()

with open(settings.JWT_SECRET_KEY_PATH, "r") as file:
    private_key = file.read()

with open(settings.JWT_PUBLIC_KEY_PATH, "r") as file:
    public_key = file.read()

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl=settings.API_V1_STR + "/auth/login",
    scopes={
        ScopeEnum.ADMIN: "Full access to everything.",
        ScopeEnum.MANAGER_FAMILY: "Edit faina family.",
        ScopeEnum.MANAGER_TACAUA: "Edit data related to tacaua.",
        ScopeEnum.MANAGER_NEI: "Edit data related to nei.",
    },
)

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

# Create the dns resolver to use for email validation (Supports caching).
resolver = caching_resolver(timeout=15)


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


def create_token(payload: dict[str, Any]) -> str:
    """Creates a new token

    **Parameters**
    * `payload` the token data payload

    **Returns**
    A JWT encoded token with the provided payload
    """
    encoded_jwt = jwt.encode(
        payload,
        private_key,
        algorithm=settings.JWT_ALGORITHM,
    )
    return encoded_jwt


def generate_response(
    db: Session,
    user: User,
    device_login: DeviceLogin | None = None,
) -> Response:
    """Creates a new authorization response for a user

    **Parameters**
    * `db`: A SQLAlchemy ORM session
    * `user`: The user's information
    * `device_login`: The device login information if refreshing the session, otherwise None

    **Returns**
    A response with the refresh token cookie set and the
    access token in the body
    """

    # Measure once the current time, the same value must be passed to the
    # created device login and refreshed token otherwise the token could be
    # denied because the dates mismatch.
    iat = datetime.utcnow()

    if device_login is None:
        # Create a new session and add it to the database if no session exists
        device_login = DeviceLogin(
            user_id=user.id,
            session_id=int(iat.timestamp()),
            refreshed_at=iat,
            expires_at=iat + settings.REFRESH_TOKEN_EXPIRE,
        )
        db.add(device_login)
    else:
        # Update the last time the token was refreshed if the session already exists
        device_login.refreshed_at = iat

    # Flush all changes to the database to ensure consistency
    db.commit()

    access_token = create_token(
        {
            "iat": iat,
            "exp": iat + settings.ACCESS_TOKEN_EXPIRE,
            # JWT requires 'sub' to be a string
            "sub": str(user.id),
            "nmec": user.nmec,
            "name": user.name,
            "surname": user.surname,
            "scopes": user.scopes,
        }
    )
    refresh_token = create_token(
        {
            "iat": iat,
            "exp": device_login.expires_at,
            # JWT requires 'sub' and 'sid' to be a string
            "sub": str(user.id),
            "sid": device_login.session_id,
        },
    )

    token_data = Token(access_token=access_token, token_type="bearer")

    response = JSONResponse(content=token_data.dict())
    response.set_cookie(
        key="refresh",
        value=refresh_token,
        expires=device_login.expires_at,
        secure=settings.PRODUCTION,
        httponly=True,
        samesite="strict",
        # Only pass the cookie to the refresh endpoint
        path=settings.API_V1_STR + "/auth/refresh",
    )
    return response


def decode_token(token: str) -> dict[str, Any]:
    return jwt.decode(
        token,
        public_key,
        algorithms=[settings.JWT_ALGORITHM],
        options={
            "require_iat": True,
            "require_exp": True,
            "require_sub": True,
        },
    )


async def verify_token(
    security_scopes: SecurityScopes,
    token: str = Depends(oauth2_scheme),
) -> dict[str, Any]:
    """Dependency for user authentication"""
    if security_scopes.scopes:
        authenticate_value = f'Bearer scope="{security_scopes.scope_str}"'
    else:
        authenticate_value = "Bearer"
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": authenticate_value},
    )
    try:
        payload = decode_token(token)
        token_scopes = payload.get("scopes", [])
    except JWTError:
        raise credentials_exception

    # Bypass scopes for admin
    if ScopeEnum.ADMIN in token_scopes:
        return payload

    # Verify that the token has all the necessary scopes
    for scope in security_scopes.scopes:
        if scope not in token_scopes:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Not enough permissions",
                headers={"WWW-Authenticate": authenticate_value},
            )

    return payload


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
            form_data.username, check_deliverability=False, dns_resolver=resolver
        )
        email = validation.email
    except EmailNotValidError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is invalid",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = authenticate_user(db, email, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return generate_response(db, user)


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


async def send_confirmation_token(email: str, name: str, uid: int):
    """Generates a confirmation token and emails it

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `uid`: The id of the user
    """
    iat = datetime.now()
    confirmation_token = create_token(
        {
            "iat": iat,
            "exp": iat + settings.CONFIRMATION_TOKEN_EXPIRE,
            # JWT requires 'sub' to be a string
            "sub": str(uid),
        },
    )
    await emailUtils.send_email_confirmation(email, name, confirmation_token)


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
    try:
        validation = validate_email(
            form_data.email, check_deliverability=True, dns_resolver=resolver
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
            send_confirmation_token, email, form_data.name, user.id
        )
    return generate_response(db, user)


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
    except (JWTError, ValueError, KeyError):
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


class VerifyResponse(BaseModel):
    status: Literal["success"]
    message: str


@router.get(
    "/verify",
    responses={401: {"description": "Invalid confirmation token"}},
    response_model=VerifyResponse,
)
async def refresh(
    token: str,
    db: Session = Depends(deps.get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid confirmation token",
        headers={"WWW-Authenticate": "Refresh"},
    )

    try:
        payload = decode_token(token)
        # Extract all needed fields inside a `try` in case a token
        # has a bad payload.
        user_id = int(payload["sub"])
    except (JWTError, ValueError, KeyError):
        raise credentials_exception

    user = crud.user.get(db, user_id)
    if user is None:
        raise credentials_exception

    crud.user.update(db, db_obj=user, obj_in={"active": True})

    return VerifyResponse(status="success", message="Account verified successfully")
