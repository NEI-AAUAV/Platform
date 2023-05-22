from datetime import datetime
from fastapi import APIRouter, HTTPException, Security
from pymongo import ReturnDocument

from app.utils import optional
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, ScopeEnum
from app.models.time_slots import TimeSlots, TIME_SLOTS_ID

from .util import fetch_time_slots

router = APIRouter()


@optional()
class TimeSlotsEditForm(TimeSlots):
    pass


@router.put("/")
async def edit_time_slots(
    form_data: TimeSlotsEditForm,
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> TimeSlots:
    """Edits the time slots"""
    initial = await fetch_time_slots(db)

    now = datetime.now()

    tablesStart = form_data.tablesStart or initial.tablesStart

    if now > tablesStart:
        raise HTTPException(
            status_code=400,
            detail="Tables start date cannot be before the current time",
        )

    tablesEnd = form_data.tablesEnd or initial.tablesEnd

    if tablesStart > tablesEnd:
        raise HTTPException(
            status_code=400, detail="Tables start date cannot be after end date"
        )

    votesStart = form_data.votesStart or initial.votesStart

    if now > votesStart:
        raise HTTPException(
            status_code=400, detail="Votes start date cannot be before the current time"
        )

    votesEnd = form_data.votesEnd or initial.votesEnd

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
