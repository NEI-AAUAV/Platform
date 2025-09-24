from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, SecurityScopes
from fastapi.responses import JSONResponse, Response

from sqlalchemy.orm import Session
from passlib.context import CryptContext
from pydantic import BaseModel, ValidationError
from jose import JWTError, jwt
from datetime import datetime, timezone
from typing import Annotated, Any, Dict, Literal, Optional, Set, Union
from loguru import logger

from app.models.user import User
from app.models.device_login import DeviceLogin
from app.models.user.user_email import UserEmail
from app.schemas.user import ScopeEnum
from app.core.config import settings
from app.core.dynamic_oauth import dynamic_oauth2_scheme


ACCESS_TOKEN_TYPE: str = "access"
REFRESH_TOKEN_TYPE: str = "refresh"
VERIFICATION_TOKEN_TYPE: str = "verification"
PASSWORD_RESET_TOKEN_TYPE: str = "reset"
MAGIC_LINK_TOKEN_TYPE: str = "magic"


with open(settings.JWT_SECRET_KEY_PATH, "r") as file:
    private_key = file.read()

with open(settings.JWT_PUBLIC_KEY_PATH, "r") as file:
    public_key = file.read()

auth_responses: Dict[Union[int, str], Dict[str, Any]] = {
    401: {"description": "Not authenticated"},
    403: {"description": "Not enough permissions"},
}

# Use the dynamic OAuth2 scheme
oauth2_scheme = dynamic_oauth2_scheme


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


class AuthData(BaseModel):
    sub: int
    nmec: Optional[int] = None
    name: str
    email: str
    surname: str
    scopes: Set[str]


async def get_auth_data(
    token: Optional[str] = Depends(oauth2_scheme),
) -> Optional[AuthData]:
    if token is None:
        return None

    try:
        payload = decode_token(token)
        token_type = payload["type"]
    except JWTError:
        return None

    # Check that the token is an access token
    if token_type != ACCESS_TOKEN_TYPE:
        return None

    try:
        auth_data = AuthData(**payload)
    except ValidationError as e:
        logger.debug(e)
        return None

    return auth_data


GetAuthData = Annotated[Optional[AuthData], Depends(get_auth_data)]


async def verify_token(
    security_scopes: SecurityScopes, auth_data: GetAuthData
) -> AuthData:
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

    if auth_data is None:
        raise credentials_exception

    # Bypass scopes for admin
    if ScopeEnum.ADMIN in auth_data.scopes:
        return auth_data

    # Verify that the token has all the necessary scopes
    for scope in security_scopes.scopes:
        if scope not in auth_data.scopes:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions",
                headers={"WWW-Authenticate": authenticate_value},
            )

    return auth_data


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

    # FIXME: refactor this to have a clean way of setting primary emails
    user_email = db.query(UserEmail).filter(user.id == UserEmail.user_id).first()

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
            "type": ACCESS_TOKEN_TYPE,
            "nmec": user.nmec,
            "email": user_email.email,
            "image": user.image,
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
            "type": REFRESH_TOKEN_TYPE,
            "sid": device_login.session_id,
        },
    )

    token_data = Token(access_token=access_token, token_type="bearer")

    response = JSONResponse(content=token_data.model_dump())
    response.set_cookie(
        key="refresh",
        value=refresh_token,
        expires=device_login.expires_at.astimezone(tz=timezone.utc),
        secure=settings.PRODUCTION,
        httponly=True,
        samesite="strict",
        # Only pass the cookie to the auth endpoints
        path=f"{settings.API_V1_STR}/auth",
    )
    return response


class OperationSuccessfulResponse(BaseModel):
    status: Literal["success"]
    message: str
