from fastapi import APIRouter, Security

from app.models.limits import Limits
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, auth_responses, ScopeEnum

from .util import fetch_limits

router = APIRouter()


@router.get(
    "/",
    responses={**auth_responses},
)
async def get_limits(
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> Limits:
    """Gets the current limits"""
    return await fetch_limits(db)
