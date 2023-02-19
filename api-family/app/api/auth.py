from enum import Enum
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, SecurityScopes
from jose import JWTError, jwt

from app.core.config import settings

with open(settings.JWT_PUBLIC_KEY_PATH, "r") as file:
    public_key = file.read()


class ScopeEnum(str, Enum):
    """Permission scope of an authenticated user."""

    ADMIN = "admin"
    MANAGER_NEI = "manager-nei"
    MANAGER_TACAUA = "manager-tacaua"
    MANAGER_FAMILY = "manager-family"
    DEFAULT = "default"


oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="http://localhost:8000/api/nei/v1/auth/login",
    scopes={
        ScopeEnum.ADMIN: "Full access to everything.",
        ScopeEnum.MANAGER_FAMILY: "Edit faina family.",
        ScopeEnum.MANAGER_TACAUA: "Edit data related to tacaua.",
        ScopeEnum.MANAGER_NEI: "Edit data related to nei.",
    },
)


async def verify_scopes(
    security_scopes: SecurityScopes,
    token: str = Depends(oauth2_scheme),
):
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
        payload = jwt.decode(
            token,
            public_key,
            algorithms=[settings.JWT_ALGORITHM],
        )
        scopes = payload.get("scopes", [])
    except JWTError:
        raise credentials_exception

    # Bypass scopes for admin
    if ScopeEnum.ADMIN in scopes:
        return

    # Verify that the token has all the necessary scopes
    for scope in security_scopes.scopes:
        if scope not in scopes:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Not enough permissions",
                headers={"WWW-Authenticate": authenticate_value},
            )
