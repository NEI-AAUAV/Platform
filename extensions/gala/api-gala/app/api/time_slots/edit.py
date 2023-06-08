from datetime import datetime, timezone
from app.core.config import SettingsDep
from fastapi import APIRouter, HTTPException, Security
from pymongo import ReturnDocument

from app.utils import optional
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, ScopeEnum, auth_responses
from app.models.time_slots import TimeSlots, TIME_SLOTS_ID

from .util import fetch_time_slots

router = APIRouter()


@optional()
class TimeSlotsEditForm(TimeSlots):
    pass


@router.put(
    "/",
    responses={
        **auth_responses,
        400: {"description": "An end date appears before a start date"},
    },
)
async def edit_time_slots(
    form_data: TimeSlotsEditForm,
    *,
    db: DatabaseDep,
    settings: SettingsDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> TimeSlots:
    """Edits the time slots"""
    initial = await fetch_time_slots(db)

    now = datetime.now(tz=timezone.utc)

    tablesStart = form_data.tablesStart or initial.tablesStart
    if tablesStart.tzinfo is None:
        tablesStart = tablesStart.replace(tzinfo=timezone.utc)

    if not settings.ALLOW_TIME_SLOTS_PAST and now > tablesStart:
        raise HTTPException(
            status_code=400,
            detail="Tables start date cannot be before the current time",
        )

    tablesEnd = form_data.tablesEnd or initial.tablesEnd
    if tablesEnd.tzinfo is None:
        tablesEnd = tablesEnd.replace(tzinfo=timezone.utc)

    if tablesStart > tablesEnd:
        raise HTTPException(
            status_code=400, detail="Tables start date cannot be after end date"
        )

    votesStart = form_data.votesStart or initial.votesStart
    if votesStart.tzinfo is None:
        votesStart = votesStart.replace(tzinfo=timezone.utc)

    if not settings.ALLOW_TIME_SLOTS_PAST and now > votesStart:
        raise HTTPException(
            status_code=400, detail="Votes start date cannot be before the current time"
        )

    votesEnd = form_data.votesEnd or initial.votesEnd
    if votesEnd.tzinfo is None:
        votesEnd = votesEnd.replace(tzinfo=timezone.utc)

    if votesStart > votesEnd:
        raise HTTPException(
            status_code=400, detail="Votes start date cannot be after end date"
        )

    res = await TimeSlots.get_collection(db).find_one_and_update(
        {"_id": TIME_SLOTS_ID},
        {"$set": form_data.dict(exclude_unset=True)},
        return_document=ReturnDocument.AFTER,
    )

    return TimeSlots.parse_obj(res)
