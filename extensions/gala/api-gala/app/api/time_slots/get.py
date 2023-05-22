from fastapi import APIRouter, Security

from app.models.time_slots import TimeSlots
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth

from .util import fetch_time_slots

router = APIRouter()


@router.get("/")
async def get_time_slots(
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth),
) -> TimeSlots:
    """Gets the current time slots config"""
    return await fetch_time_slots(db)
