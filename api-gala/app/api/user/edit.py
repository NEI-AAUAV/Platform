from fastapi import APIRouter, Security, HTTPException
from pymongo import ReturnDocument

from app.models.user import User
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, ScopeEnum
from app.utils import optional

router = APIRouter()


@optional(exclude={"id"})
class UserEditForm(User):
    id: int


@router.put("/")
async def edit_user(
    form_data: UserEditForm,
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> User:
    """Edits a user"""
    res = await User.get_collection(db).find_one_and_update(
        {"_id": form_data.id},
        {"$set": form_data.dict(exclude_unset=True, exclude={"id"})},
        return_document=ReturnDocument.AFTER,
    )

    if res is None:
        raise HTTPException(status_code=404, detail="User doesn't exist")

    return User.parse_obj(res)
