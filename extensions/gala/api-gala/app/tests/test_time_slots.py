from datetime import MAXYEAR, datetime
from aiocache.serializers.serializers import json
import pytest
from httpx import AsyncClient
from app.api.auth import ScopeEnum
from app.api.time_slots.edit import TimeSlotsEditForm

from app.core.config import Settings
from app.core.db.types import DBType
from app.models.time_slots import TIME_SLOTS_ID, TimeSlots

from ._utils import auth_data

test_time_slots = TimeSlots(
    tablesStart=datetime(4341, 1, 1),
    tablesEnd=datetime(4342, 2, 2),
    votesStart=datetime(4343, 3, 3),
    votesEnd=datetime(4344, 4, 4),
)

# ====================
# == GET TIME SLOTS ==
# ====================


@pytest.mark.asyncio
async def test_get_time_slots_logged_out(
    settings: Settings, client: AsyncClient
) -> None:
    response = await client.get(f"{settings.API_V1_STR}/slots/")
    assert response.status_code == 200


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_time_slots(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await TimeSlots.get_collection(db).update_one(
        {"_id": TIME_SLOTS_ID}, {"$set": test_time_slots.dict()}, upsert=True
    )

    response = await client.get(f"{settings.API_V1_STR}/slots/")
    assert response.status_code == 200
    time_slots_res = TimeSlots(**response.json())
    assert time_slots_res == test_time_slots


# =====================
# == EDIT TIME SLOTS ==
# =====================


@pytest.mark.asyncio
async def test_edit_time_slots_logged_out(
    settings: Settings, client: AsyncClient
) -> None:
    form = TimeSlotsEditForm(
        tablesStart=datetime(MAXYEAR, 1, 1),
        tablesEnd=datetime(MAXYEAR, 1, 2),
    )
    response = await client.put(
        f"{settings.API_V1_STR}/slots/",
        json=json.loads(form.json(exclude_unset=True)),
    )
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_edit_time_slots_unauthorized(
    settings: Settings, client: AsyncClient
) -> None:
    form = TimeSlotsEditForm(
        tablesStart=datetime(MAXYEAR, 1, 1),
        tablesEnd=datetime(MAXYEAR, 1, 2),
    )
    response = await client.put(
        f"{settings.API_V1_STR}/slots/",
        json=json.loads(form.json(exclude_unset=True)),
    )
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_time_slots(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await TimeSlots.get_collection(db).update_one(
        {"_id": TIME_SLOTS_ID}, {"$set": test_time_slots.dict()}, upsert=True
    )

    form = TimeSlotsEditForm(
        tablesStart=datetime(MAXYEAR, 1, 1),
        tablesEnd=datetime(MAXYEAR, 1, 2),
    )
    response = await client.put(
        f"{settings.API_V1_STR}/slots/",
        json=json.loads(form.json(exclude_unset=True)),
    )
    assert response.status_code == 200
    time_slots = TimeSlots(**response.json())

    assert time_slots.tablesStart == datetime(MAXYEAR, 1, 1)
    assert time_slots.tablesEnd == datetime(MAXYEAR, 1, 2)

    db_res = await TimeSlots.get_collection(db).find_one({"_id": TIME_SLOTS_ID})
    assert db_res is not None
    db_time_slots_res = TimeSlots(**db_res)

    test_time_slots_mod = test_time_slots.copy()
    test_time_slots_mod.tablesStart = datetime(MAXYEAR, 1, 1)
    test_time_slots_mod.tablesEnd = datetime(MAXYEAR, 1, 2)

    assert time_slots == test_time_slots_mod
    assert test_time_slots_mod == db_time_slots_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_time_slots_end_before_start(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await TimeSlots.get_collection(db).update_one(
        {"_id": TIME_SLOTS_ID}, {"$set": test_time_slots.dict()}, upsert=True
    )

    form = TimeSlotsEditForm(
        tablesStart=datetime(MAXYEAR, 1, 2),
        tablesEnd=datetime(MAXYEAR, 1, 1),
    )
    response = await client.put(
        f"{settings.API_V1_STR}/slots/",
        json=json.loads(form.json(exclude_unset=True)),
    )
    assert response.status_code == 400

    db_res = await TimeSlots.get_collection(db).find_one({"_id": TIME_SLOTS_ID})
    assert db_res is not None
    db_time_slots_res = TimeSlots(**db_res)
    assert test_time_slots == db_time_slots_res
