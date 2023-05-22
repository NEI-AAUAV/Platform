from datetime import MAXYEAR, MINYEAR, datetime
from typing import List
from app.models.time_slots import TIME_SLOTS_ID, TimeSlots

from app.models.user import User
from app.core.db.types import DBType
from app.api.auth import AuthData, ScopeEnum


def auth_data(*, sub: int = 0, scopes: List[ScopeEnum] = []) -> AuthData:
    return AuthData(sub=sub, nmec=0, name="J", surname="C", scopes=scopes)


async def create_test_user(*, id: int, db: DBType) -> None:
    test_user = User(_id=id, matriculation=None, nmec=1, email="dev@dev.dev", name="J")
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))


async def mark_open_timeslot(*, db: DBType) -> None:
    time_slot = TimeSlots(
        votesStart=datetime(MINYEAR, 1, 1),
        votesEnd=datetime(MAXYEAR, 12, 31),
        tablesStart=datetime(MINYEAR, 1, 1),
        tablesEnd=datetime(MAXYEAR, 12, 31),
    )
    await TimeSlots.get_collection(db).update_one(
        {"_id": TIME_SLOTS_ID}, {"$set": time_slot.dict()}, upsert=True
    )
