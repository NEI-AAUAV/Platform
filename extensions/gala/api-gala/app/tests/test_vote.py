import pytest
from httpx import AsyncClient
from app.api.auth import ScopeEnum
from app.api.vote.create import VoteCategoryCreateForm
from app.api.vote.edit import VoteCategoryEditForm
from app.api.vote.vote import VoteForm

from app.core.config import Settings
from app.core.db.types import DBType
from app.models.vote import Vote, VoteCategory, VoteListing

from ._utils import (
    auth_data,
    create_test_user,
    mark_open_timeslot,
    mark_closed_timeslot,
)

test_category = VoteCategory(
    _id=0, category="GOOD", options=["Option 1", "Option 2"], votes=[]
)


# ==========================
# == LIST VOTE CATEGORIES ==
# ==========================


@pytest.mark.asyncio
async def test_list_categories_logged_out(
    settings: Settings, client: AsyncClient
) -> None:
    response = await client.get(f"{settings.API_V1_STR}/votes/list")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_list_categories(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))
    test_category2 = test_category.copy()
    test_category2.category += "2"
    test_category2.id += 1
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 2

    VoteListing(**body[0])
    VoteListing(**body[1])


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_list_categories_scores(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_category2 = test_category.copy()
    test_category2.votes = [
        Vote(uid=1, option=1),
        Vote(uid=2, option=0),
        Vote(uid=3, option=0),
        Vote(uid=4, option=1),
        Vote(uid=5, option=1),
    ]
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    category = VoteListing(**body[0])
    assert not category.already_voted
    assert category.scores == [2, 3]


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_list_categories_already_voted(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_category2 = test_category.copy()
    test_category2.votes = [
        Vote(uid=0, option=1),
    ]
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/list")
    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 1

    category = VoteListing(**body[0])
    assert category.already_voted
    assert category.scores == [0, 1]


# =======================
# == GET VOTE CATEGORY ==
# =======================


@pytest.mark.asyncio
async def test_get_category_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/votes/1")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_category_not_found(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/votes/1")
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_category(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/{test_category.id}")
    assert response.status_code == 200
    body = response.json()

    category = VoteListing(**body)
    assert category.id == test_category.id
    assert category.category == test_category.category
    assert category.options == test_category.options


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_get_category_scores(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_category2 = test_category.copy()
    test_category2.votes = [
        Vote(uid=1, option=1),
        Vote(uid=2, option=0),
        Vote(uid=3, option=0),
        Vote(uid=4, option=1),
        Vote(uid=5, option=1),
    ]
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/{test_category2.id}")
    assert response.status_code == 200
    body = response.json()

    category = VoteListing(**body)
    assert category.id == test_category.id
    assert category.category == test_category.category
    assert category.options == test_category.options
    assert not category.already_voted
    assert category.scores == [2, 3]


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_get_category_already_voted(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    test_category2 = test_category.copy()
    test_category2.votes = [
        Vote(uid=0, option=1),
    ]
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/votes/{test_category2.id}")
    assert response.status_code == 200
    body = response.json()

    category = VoteListing(**body)
    assert category.id == test_category.id
    assert category.category == test_category.category
    assert category.options == test_category.options
    assert category.already_voted
    assert category.scores == [0, 1]


# =======================
# == NEW VOTE CATEGORY ==
# =======================


@pytest.mark.asyncio
async def test_new_category_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.post(f"{settings.API_V1_STR}/votes/new")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_new_category_unauthorized(
    settings: Settings, client: AsyncClient
) -> None:
    form = VoteCategoryCreateForm(category="GOOD", options=["Option 1", "Option 2"])
    response = await client.post(f"{settings.API_V1_STR}/votes/new", json=form.dict())
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_new_category(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    form = VoteCategoryCreateForm(category="GOOD", options=["Option 1", "Option 2"])
    response = await client.post(f"{settings.API_V1_STR}/votes/new", json=form.dict())
    assert response.status_code == 200
    body = response.json()

    category = VoteCategory(**body)
    assert category.category == "GOOD"
    assert category.options == ["Option 1", "Option 2"]
    assert len(category.votes) == 0

    db_res = await VoteCategory.get_collection(db).find_one({"_id": category.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)
    assert category == db_category_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_new_category_same_name(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    form = VoteCategoryCreateForm(
        category=test_category.category, options=["Option 1", "Option 2"]
    )
    response = await client.post(f"{settings.API_V1_STR}/votes/new", json=form.dict())
    assert response.status_code == 409


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_new_category_ICU_equality(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    new_category = test_category.category.lower()
    assert test_category.category != new_category

    form = VoteCategoryCreateForm(
        category=new_category, options=["Option 1", "Option 2"]
    )
    response = await client.post(f"{settings.API_V1_STR}/votes/new", json=form.dict())
    assert response.status_code == 409


# ========================
# == EDIT VOTE CATEGORY ==
# ========================


@pytest.mark.asyncio
async def test_edit_category_logged_out(
    settings: Settings, client: AsyncClient
) -> None:
    response = await client.put(f"{settings.API_V1_STR}/votes/1/edit")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_edit_category_unauthorized(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))
    form = VoteCategoryEditForm(category=test_category.category + "2")
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/edit",
        json=form.dict(exclude_unset=True),
    )
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_category_not_found(settings: Settings, client: AsyncClient) -> None:
    form = VoteCategoryEditForm(category=test_category.category + "2")
    response = await client.put(
        f"{settings.API_V1_STR}/votes/1/edit", json=form.dict(exclude_unset=True)
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_category(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    new_name = test_category.category + "2"
    assert new_name != test_category.category

    form = VoteCategoryEditForm(category=new_name)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/edit",
        json=form.dict(exclude_unset=True),
    )
    assert response.status_code == 200
    category = VoteCategory(**response.json())

    assert category.category == new_name
    assert category.options == test_category.options

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)

    test_category_mod = test_category.copy()
    test_category_mod.category = new_name

    assert category == test_category_mod
    assert test_category_mod == db_category_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_category_same_name(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))
    test_category2 = test_category.copy()
    test_category2.id += 1
    test_category2.category += "2"
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    form = VoteCategoryEditForm(category=test_category.category)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category2.id}/edit",
        json=form.dict(exclude_unset=True),
    )
    assert response.status_code == 409

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category2.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)
    assert test_category2 == db_category_res


# ===============
# == CAST VOTE ==
# ===============


@pytest.mark.asyncio
async def test_cast_vote_logged_out(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    response = await client.put(f"{settings.API_V1_STR}/votes/1/cast")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_cast_vote_no_user(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))
    form = VoteForm(option=0)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/cast",
        json=form.dict(),
    )
    assert response.status_code == 400


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_cast_vote(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    form = VoteForm(option=0)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/cast",
        json=form.dict(),
    )
    assert response.status_code == 200
    listing = VoteListing(**response.json())

    assert listing.already_voted
    assert listing.scores == [1, 0]

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)

    mod_test_category = test_category.copy()
    mod_test_category.votes = mod_test_category.votes.copy()
    mod_test_category.votes.append(Vote(uid=0, option=0))

    assert mod_test_category == db_category_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_cast_vote_already_voted(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    test_category2 = test_category.copy()
    test_category2.votes = test_category2.votes.copy()
    test_category2.votes.append(Vote(uid=0, option=0))
    await VoteCategory.get_collection(db).insert_one(test_category2.dict(by_alias=True))

    form = VoteForm(option=0)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category2.id}/cast",
        json=form.dict(),
    )
    assert response.status_code == 409

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category2.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)
    assert test_category2 == db_category_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_cast_vote_bad_option(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_open_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    form = VoteForm(option=len(test_category.options))
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/cast",
        json=form.dict(),
    )
    assert response.status_code == 400

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)
    assert test_category == db_category_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(sub=0)],
    indirect=["client"],
)
async def test_cast_vote_time_slot_closed(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await mark_closed_timeslot(db=db)
    await create_test_user(id=0, db=db)
    await VoteCategory.get_collection(db).insert_one(test_category.dict(by_alias=True))

    form = VoteForm(option=0)
    response = await client.put(
        f"{settings.API_V1_STR}/votes/{test_category.id}/cast",
        json=form.dict(),
    )
    assert response.status_code == 409

    db_res = await VoteCategory.get_collection(db).find_one({"_id": test_category.id})
    assert db_res is not None
    db_category_res = VoteCategory(**db_res)
    assert test_category == db_category_res
