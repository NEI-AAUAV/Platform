from fastapi import APIRouter, Security
from pymongo import ReturnDocument

from app.utils import optional
from app.core.db import DatabaseDep
from app.models.limits import LIMITS_ID, Limits
from app.api.auth import AuthData, api_nei_auth, ScopeEnum, auth_responses

router = APIRouter()


@optional()
class LimitsEditForm(Limits):
    pass


@router.put(
    "/",
    responses={
        **auth_responses,
    },
)
async def edit_limits(
    form_data: LimitsEditForm,
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> Limits:
    """Edits the limits"""
    res = await Limits.get_collection(db).find_one_and_update(
        {"_id": LIMITS_ID},
        {"$set": form_data.dict(exclude_unset=True)},
        return_document=ReturnDocument.AFTER,
    )

    return Limits.parse_obj(res)
