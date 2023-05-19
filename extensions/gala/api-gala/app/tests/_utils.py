from typing import List

from app.models.user import User
from app.core.db.types import DBType
from app.api.auth import AuthData, ScopeEnum


def auth_data(*, sub: int = 0, scopes: List[ScopeEnum] = []) -> AuthData:
    return AuthData(sub=sub, nmec=0, name="J", surname="C", scopes=scopes)


async def create_test_user(*, id: int, db: DBType) -> None:
    test_user = User(_id=id, matriculation=None, nmec=1, email="dev@dev.dev", name="J")
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))
