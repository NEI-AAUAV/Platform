from fastapi import APIRouter, Security, HTTPException
from typing import List

from app.models.user import User
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, ScopeEnum

router = APIRouter()


@router.get("/")
async def list_users(
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> List[User]:
    """List all users"""
    res = await User.get_collection(db).find().to_list(None)
    return list(map(lambda user: User.parse_obj(user), res))


@router.get("/me")
async def get_self(
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> User:
    """Fetches the self user information"""
    res = await User.get_collection(db).find_one({"_id": auth.sub})

    if res is None:
        raise HTTPException(status_code=404, detail="User doesn't exist")

    return User.parse_obj(res)
