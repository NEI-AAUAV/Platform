from datetime import datetime
from fastapi import HTTPException, Security

from app.core.db import DatabaseDep
from app.core.db.types import DBType
from app.models.time_slots import TimeSlots, TIME_SLOTS_ID
from app.api.auth import AuthData, ScopeEnum, api_nei_auth


async def fetch_time_slots(db: DBType) -> TimeSlots:
    res = await TimeSlots.get_collection(db).find_one({"_id": TIME_SLOTS_ID})
    return TimeSlots.parse_obj(res)


async def check_tables_open(
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> TimeSlots:
    time_slots = await fetch_time_slots(db)

    if ScopeEnum.ADMIN in auth.scopes or ScopeEnum.MANAGER_JANTAR_GALA in auth.scopes:
        return time_slots

    now = datetime.now()
    if now < time_slots.tablesStart or now > time_slots.tablesEnd:
        raise HTTPException(status_code=409, detail="Tables aren't open")

    return time_slots


async def check_votes_open(
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> TimeSlots:
    time_slots = await fetch_time_slots(db)

    if ScopeEnum.ADMIN in auth.scopes or ScopeEnum.MANAGER_JANTAR_GALA in auth.scopes:
        return time_slots

    now = datetime.now()
    if now < time_slots.votesStart or now > time_slots.votesEnd:
        raise HTTPException(status_code=409, detail="Votes aren't open")

    return time_slots
