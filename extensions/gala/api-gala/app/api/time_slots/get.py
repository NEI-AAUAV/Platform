from fastapi import APIRouter

from app.models.time_slots import TimeSlots
from app.core.db import DatabaseDep
from app.api.auth import auth_responses

from .util import fetch_time_slots

router = APIRouter()


@router.get(
    "/",
    responses={**auth_responses},
)
async def get_time_slots(
    *,
    db: DatabaseDep,
) -> TimeSlots:
    """Gets the current time slots config"""
    return await fetch_time_slots(db)
