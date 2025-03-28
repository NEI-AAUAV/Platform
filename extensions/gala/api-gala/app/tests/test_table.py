import pytest
from typing import List
from httpx import AsyncClient
from app.api.auth import ScopeEnum
from app.api.table.confirm import TableApprovalForm
from app.api.table.create import TableCreateForm
from app.api.table.edit import TableEditForm
from app.api.table.merge import TableMergeForm
from app.api.table.reserve import TableReservationForm
from app.api.table.transfer import TableTransferForm

from app.core.config import Settings
from app.core.db.types import DBType
from app.models.table import Companion, DishType, Table, TablePerson

from ._utils import (
    auth_data,
    create_test_user,
    mark_open_timeslot,
    mark_closed_timeslot,
)

test_table = Table(_id=1, name=None, head=None, seats=3, persons=[])


def dummy_person(
    *, id: int, confirmed: bool, companions: List[Companion] = []
) -> TablePerson:
    return TablePerson(
        id=id,
        confirmed=confirmed,
        companions=companions,
        dish=DishType.NORMAL,
        allergies="",
    )


# =================
# == LIST TABLES ==
# =================


@pytest.mark.asyncio
async def test_list_tables_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_list_tables(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))
    test_table2 = test_table.copy()
    test_table2.id += 1
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 2

    Table(**body[0])
    Table(**body[1])


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_list_tables_sanitize(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    table = Table(**body[0])
    assert len(table.persons) == 1
    assert all(person.confirmed for person in table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_list_tables_sanitize_self(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=0, confirmed=False),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    table = Table(**body[0])
    assert len(table.persons) == 2
    assert not all(person.confirmed for person in table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_list_tables_sanitize_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
        dummy_person(id=2, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    table = Table(**body[0])
    assert len(table.persons) == 3
    assert not all(person.confirmed for person in table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_list_tables_sanitize_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    table = Table(**body[0])
    assert len(table.persons) == 2
    assert not all(person.confirmed for person in table.persons)


# ================
# == GET TABLES ==
# ================


@pytest.mark.asyncio
async def test_get_table_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/table/1")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_table(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/{test_table.id}")
    assert response.status_code == 200
    res_table = Table(**response.json())
    assert res_table == test_table


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_get_table_sanitize(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/{test_table2.id}")

    assert response.status_code == 200
    res_table = Table(**response.json())
    assert len(res_table.persons) == 1
    assert all(person.confirmed for person in res_table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_get_table_sanitize_self(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=0, confirmed=False),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/{test_table2.id}")

    assert response.status_code == 200
    res_table = Table(**response.json())
    assert len(res_table.persons) == 2
    assert not all(person.confirmed for person in res_table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_get_table_sanitize_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
        dummy_person(id=2, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/{test_table2.id}")

    assert response.status_code == 200
    res_table = Table(**response.json())
    assert len(res_table.persons) == 3
    assert not all(person.confirmed for person in res_table.persons)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_get_table_sanitize_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table2 = test_table.copy()
    test_table2.head = 2
    test_table2.persons = [
        dummy_person(id=2, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/table/{test_table2.id}")

    assert response.status_code == 200
    res_table = Table(**response.json())
    assert len(res_table.persons) == 2
    assert not all(person.confirmed for person in res_table.persons)


# ===============
# == NEW TABLE ==
# ===============


@pytest.mark.asyncio
async def test_new_table_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.post(f"{settings.API_V1_STR}/table/new")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_new_table_unauthorized(settings: Settings, client: AsyncClient) -> None:
    response = await client.post(f"{settings.API_V1_STR}/table/new")
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_new_table(settings: Settings, client: AsyncClient, db: DBType) -> None:
    form = TableCreateForm(seats=4)
    response = await client.post(f"{settings.API_V1_STR}/table/new", json=form.dict())

    assert response.status_code == 200
    table_res = Table(**response.json())
    assert table_res.seats == form.seats

    expected_table = Table(
        _id=table_res.id, head=None, name=None, seats=form.seats, persons=[]
    )

    assert table_res == expected_table

    db_res = await Table.get_collection(db).find_one({"_id": table_res.id})

    assert db_res is not None
    db_table_res = Table(**db_res)
    assert table_res == db_table_res


# ================
# == EDIT TABLE ==
# ================


@pytest.mark.asyncio
async def test_edit_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.put(f"{settings.API_V1_STR}/table/1/edit")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_edit_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    form = TableEditForm(name="BAD")
    response = await client.put(f"{settings.API_V1_STR}/table/1/edit", json=form.dict())
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_edit_table_unauthorized(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableEditForm(name="BAD")
    response = await client.put(
        f"{settings.API_V1_STR}/table/{test_table2.id}/edit", json=form.dict()
    )
    assert response.status_code == 403

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_edit_table_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableEditForm(name="GOOD")
    response = await client.put(
        f"{settings.API_V1_STR}/table/{test_table2.id}/edit", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert table_res == db_table_res

    mod_test_table2 = test_table2.copy()
    mod_test_table2.name = form.name
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_table_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableEditForm(name="GOOD")
    response = await client.put(
        f"{settings.API_V1_STR}/table/{test_table2.id}/edit", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert table_res == db_table_res

    mod_test_table2 = test_table2.copy()
    mod_test_table2.name = form.name

    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_edit_table_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableEditForm(name="GOOD")
    response = await client.put(
        f"{settings.API_V1_STR}/table/{test_table2.id}/edit", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


# ===================
# == RESERVE TABLE ==
# ===================


@pytest.mark.asyncio
async def test_reserve_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.post(f"{settings.API_V1_STR}/table/1/reserve")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/1/reserve", json=form.dict()
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_empty(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table.id}/reserve", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table = test_table.copy()
    mod_test_table.head = 0
    mod_test_table.persons = [
        dummy_person(id=0, confirmed=True),
    ]

    assert table_res == db_table_res
    assert mod_test_table == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_non_empty(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/reserve", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.persons.append(
        dummy_person(id=0, confirmed=False),
    )

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_already_in_another_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))
    test_table3 = test_table.copy()
    test_table3.id += 1
    await Table.get_collection(db).insert_one(test_table3.dict(by_alias=True))

    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table3.id}/reserve", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res

    db_res = await Table.get_collection(db).find_one({"_id": test_table3.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table3 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_full_companions(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    test_table2 = test_table.copy()
    test_table2.seats = 2
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    companions = [
        Companion(dish=DishType.NORMAL),
    ]
    form = TableReservationForm(dish=DishType.NORMAL, companions=companions)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/reserve", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = 0
    mod_test_table2.persons = [
        dummy_person(id=0, confirmed=True, companions=companions)
    ]

    assert table_res == mod_test_table2
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_too_many_companions(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    test_table2 = test_table.copy()
    test_table2.seats = 2
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    companions = [
        Companion(dish=DishType.NORMAL),
        Companion(dish=DishType.NORMAL),
    ]
    form = TableReservationForm(dish=DishType.NORMAL, companions=companions)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/reserve", json=form.dict()
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_no_user(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table.id}/reserve", json=form.dict()
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_reserve_table_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    form = TableReservationForm(dish=DishType.NORMAL, companions=[])
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table.id}/reserve", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table == db_table_res


# ===================
# == CONFIRM TABLE ==
# ===================


@pytest.mark.asyncio
async def test_confirm_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.patch(f"{settings.API_V1_STR}/table/1/confirm")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_confirm_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    form = TableApprovalForm(uid=0, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/1/confirm", json=form.dict()
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_unauthorized(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=1, db=db)
    await create_test_user(id=2, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
        dummy_person(id=2, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=2, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=1, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.persons[1].confirmed = True

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_confirm_table_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=1, db=db)
    await create_test_user(id=2, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
        dummy_person(id=2, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=2, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.persons[1].confirmed = True

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_change_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=0, confirm=False)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_not_in_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=2, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_confirm_false(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=1, confirm=False)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.persons[1].confirmed = False

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_full(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    await create_test_user(id=2, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.seats = 2
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
        dummy_person(id=2, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=2, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_full_companions(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=2, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.seats = 2
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(
            id=2, confirmed=False, companions=[Companion(dish=DishType.NORMAL)]
        ),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=2, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_confirm_table_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await create_test_user(id=1, db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableApprovalForm(uid=1, confirm=True)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/confirm", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


# ====================
# == TRANSFER TABLE ==
# ====================


@pytest.mark.asyncio
async def test_transfer_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.patch(f"{settings.API_V1_STR}/table/1/transfer")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_transfer_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    form = TableTransferForm(uid=0)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/1/transfer", json=form.dict()
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_transfer_table_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableTransferForm(uid=1)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/transfer", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = 1
    mod_test_table2.persons[1].confirmed = True

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_transfer_table_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
        dummy_person(id=2, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableTransferForm(uid=2)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/transfer", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = 2
    mod_test_table2.persons[1].confirmed = True

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_transfer_table_not_in_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableTransferForm(uid=1)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/transfer", json=form.dict()
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_transfer_table_full_companions(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(
            id=1, confirmed=False, companions=[Companion(dish=DishType.NORMAL)]
        ),
        dummy_person(id=2, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableTransferForm(uid=1)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/transfer", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_transfer_table_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableTransferForm(uid=1)
    response = await client.patch(
        f"{settings.API_V1_STR}/table/{test_table2.id}/transfer", json=form.dict()
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


# =================
# == LEAVE TABLE ==
# =================


@pytest.mark.asyncio
async def test_leave_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.delete(f"{settings.API_V1_STR}/table/1/leave")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_leave_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.delete(f"{settings.API_V1_STR}/table/1/leave")
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_leave_table(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/leave"
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    del mod_test_table2.persons[0]

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_leave_table_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/leave"
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = None
    mod_test_table2.name = None
    mod_test_table2.persons.clear()

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_leave_table_head_non_empty(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/leave"
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_leave_table_not_in_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    response = await client.delete(f"{settings.API_V1_STR}/table/{test_table.id}/leave")
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_leave_table_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/leave"
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


# ==================
# == REMOVE TABLE ==
# ==================


@pytest.mark.asyncio
async def test_remove_table_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.delete(f"{settings.API_V1_STR}/table/1/remove/0")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_remove_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.delete(f"{settings.API_V1_STR}/table/1/remove/0")
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/1"
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    del mod_test_table2.persons[1]

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table_head(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/0"
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = None
    mod_test_table2.name = None
    mod_test_table2.persons.clear()

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0, scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_remove_table_manager(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 1
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/1"
    )
    assert response.status_code == 200
    table_res = Table(**response.json())

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)

    mod_test_table2 = test_table2.copy()
    mod_test_table2.head = None
    mod_test_table2.name = None
    mod_test_table2.persons.clear()

    assert table_res == db_table_res
    assert mod_test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table_head_non_empty(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=False),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/0"
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table_not_in_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table.id}/remove/0"
    )
    assert response.status_code == 403

    db_res = await Table.get_collection(db).find_one({"_id": test_table.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table_target_not_in_table(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.name = "GOOD"
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/1"
    )
    assert response.status_code == 400

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_remove_table_time_slots_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    test_table2 = test_table.copy()
    test_table2.head = 0
    test_table2.persons = [
        dummy_person(id=0, confirmed=True),
        dummy_person(id=1, confirmed=True),
    ]
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    response = await client.delete(
        f"{settings.API_V1_STR}/table/{test_table2.id}/remove/1"
    )
    assert response.status_code == 409

    db_res = await Table.get_collection(db).find_one({"_id": test_table2.id})
    assert db_res is not None
    db_table_res = Table(**db_res)
    assert test_table2 == db_table_res


# ===================
# === MERGE TABLE ===
# ===================


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_merge_table_not_found(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await Table.get_collection(db).insert_one(test_table.dict(by_alias=True))
    form = TableMergeForm(tid=2)
    response = await client.post(
        f"{settings.API_V1_STR}/table/1/merge", json=form.dict()
    )
    assert response.status_code == 404

    form = TableMergeForm(tid=1)
    response = await client.post(
        f"{settings.API_V1_STR}/table/2/merge", json=form.dict()
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_merge_table_empty(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table1 = Table(
        _id=1,
        name="Mesa#1",
        head=0,
        seats=3,
        persons=[dummy_person(id=0, confirmed=True)],
    )
    test_table2 = Table(_id=2, name=None, head=None, seats=3, persons=[])

    await Table.get_collection(db).insert_one(test_table1.dict(by_alias=True))
    await Table.get_collection(db).insert_one(test_table2.dict(by_alias=True))

    form = TableMergeForm(tid=2)
    response = await client.post(
        f"{settings.API_V1_STR}/table/1/merge", json=form.dict()
    )
    assert response.status_code == 409
    response = response.json()
    assert response["detail"] == "Cannot merge empty tables"

    form = TableMergeForm(tid=1)
    response = await client.post(
        f"{settings.API_V1_STR}/table/2/merge", json=form.dict()
    )
    assert response.status_code == 409
    response = response.json()
    assert response["detail"] == "Cannot merge empty tables"


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_merge_table_without_space(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table1 = Table(
        _id=1,
        name="Mesa#1",
        head=1,
        seats=3,
        persons=[
            dummy_person(id=1, confirmed=True),
            dummy_person(
                id=2, confirmed=True, companions=[Companion(dish=DishType.NORMAL)]
            ),
        ],
    )
    test_table2 = Table(
        _id=2,
        name="Mesa#2",
        head=3,
        seats=3,
        persons=[
            dummy_person(id=3, confirmed=True),
        ],
    )
    await Table.get_collection(db).insert_many(
        [test_table1.dict(by_alias=True), test_table2.dict(by_alias=True)]
    )

    form = TableMergeForm(tid=test_table2.id)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table1.id}/merge", json=form.dict()
    )
    assert response.status_code == 409
    response = response.json()
    assert response["detail"] == "No space available to merge tables"

    form = TableMergeForm(tid=test_table1.id)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/merge", json=form.dict()
    )
    assert response.status_code == 409
    response = response.json()
    assert response["detail"] == "No space available to merge tables"

    form = TableMergeForm(tid=test_table1.id, force_merge=True)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/merge", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())
    assert table_res.id == test_table2.id
    assert table_res.name == test_table2.name
    assert table_res.head == test_table2.head
    assert table_res.seats == test_table2.seats + 1
    assert table_res.persons == test_table2.persons + test_table1.persons


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_merge_table_with_space(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_table1 = Table(
        _id=1,
        name="Mesa#1",
        head=1,
        seats=3,
        persons=[
            dummy_person(id=1, confirmed=True),
            dummy_person(
                id=2, confirmed=False, companions=[Companion(dish=DishType.NORMAL)]
            ),
        ],
    )
    test_table2 = Table(
        _id=2,
        name="Mesa#2",
        head=0,
        seats=5,
        persons=[
            dummy_person(id=0, confirmed=True),
            dummy_person(id=3, confirmed=False),
        ],
    )
    await Table.get_collection(db).insert_many(
        [test_table1.dict(by_alias=True), test_table2.dict(by_alias=True)]
    )

    form = TableMergeForm(tid=test_table1.id, force_merge=False)
    response = await client.post(
        f"{settings.API_V1_STR}/table/{test_table2.id}/merge", json=form.dict()
    )
    assert response.status_code == 200
    table_res = Table(**response.json())
    assert table_res.seats == test_table2.seats
    assert table_res.persons == test_table2.persons + test_table1.persons
