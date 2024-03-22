from typing import List

from app.api.api_v1.auth import AuthData
from app.schemas.user.user import ScopeEnum


def auth_data(*, sub: int = 0, scopes: List[ScopeEnum] = []) -> AuthData:
    return AuthData(
        sub=sub, nmec=0, name="J", surname="C", email="dev@dev.dev", scopes=set(scopes)
    )
