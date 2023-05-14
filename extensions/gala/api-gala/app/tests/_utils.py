from typing import List
from app.api.auth import AuthData, ScopeEnum


def auth_data(*, sub: int = 0, scopes: List[ScopeEnum] = []) -> AuthData:
    return AuthData(sub=sub, nmec=0, name="J", surname="C", scopes=scopes)
