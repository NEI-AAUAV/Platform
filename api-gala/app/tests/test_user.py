import pytest
from httpx import AsyncClient
from app.api.auth import ScopeEnum
from app.api.user.create import UserCreateForm
from app.api.user.edit import UserEditForm

from app.core.config import Settings
from app.core.db.types import DBType
from app.models.user import DishType, User

from ._utils import auth_data

test_user = User(
    _id=0,
    matriculation=None,
    nmec=0,
    email="dev@dev.dev",
    name="dev",
    dish=DishType.NORMAL,
    has_payed=False,
    allergies="",
)

# ================
# == LIST USERS ==
# ================


@pytest.mark.asyncio
async def test_list_users_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/users")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_list_users_unauthorized(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/users")
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_list_users(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))
    test_user2 = test_user.copy()
    test_user2.id = 2
    await User.get_collection(db).insert_one(test_user2.dict(by_alias=True))

    response = await client.get(f"{settings.API_V1_STR}/users")

    assert response.status_code == 200
    body = response.json()
    assert isinstance(body, list)
    assert len(body) == 2

    User(**body[0])
    User(**body[1])


# ===============
# == EDIT USER ==
# ===============


@pytest.mark.asyncio
async def test_edit_user_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.put(f"{settings.API_V1_STR}/users")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_edit_user_unauthorized(settings: Settings, client: AsyncClient) -> None:
    response = await client.put(f"{settings.API_V1_STR}/users")
    assert response.status_code == 403


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_user_not_found(settings: Settings, client: AsyncClient) -> None:
    form = UserEditForm(id=test_user.id, has_payed=not test_user.has_payed)
    response = await client.put(
        f"{settings.API_V1_STR}/users",
        json=form.dict(exclude_unset=True),
    )
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data(scopes=[ScopeEnum.MANAGER_JANTAR_GALA])],
    indirect=["client"],
)
async def test_edit_user(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))
    form = UserEditForm(id=test_user.id, has_payed=not test_user.has_payed)
    response = await client.put(
        f"{settings.API_V1_STR}/users",
        json=form.dict(exclude_unset=True),
    )
    assert response.status_code == 200
    res_user = User(**response.json())
    assert res_user.id == test_user.id
    assert res_user.name == test_user.name
    assert res_user.has_payed == (not test_user.has_payed)

    db_res = await User.get_collection(db).find_one({"_id": res_user.id})

    assert db_res is not None
    db_user_res = User(**db_res)
    assert res_user == db_user_res

    mod_test_user = test_user.copy()
    mod_test_user.has_payed = not test_user.has_payed

    assert mod_test_user == db_user_res


# =================
# == CREATE USER ==
# =================


@pytest.mark.asyncio
async def test_create_user_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.post(f"{settings.API_V1_STR}/users")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_create_user(settings: Settings, client: AsyncClient, db: DBType) -> None:
    form = UserCreateForm(dish=DishType.NORMAL, email="test@local.test")
    response = await client.post(f"{settings.API_V1_STR}/users", json=form.dict())
    assert response.status_code == 200
    user_res = User(**response.json())
    assert user_res.email == form.email

    db_res = await User.get_collection(db).find_one({"_id": user_res.id})

    assert db_res is not None
    db_user_res = User(**db_res)
    assert user_res == db_user_res


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_create_user_repeated(
    settings: Settings, client: AsyncClient, db: DBType
) -> None:
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))
    form = UserCreateForm(dish=DishType.NORMAL, email="test@local.test")
    response = await client.post(f"{settings.API_V1_STR}/users", json=form.dict())
    assert response.status_code == 409


# ==============
# == GET USER ==
# ==============


@pytest.mark.asyncio
async def test_get_user_logged_out(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/users/me")
    assert response.status_code == 401


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_user_not_created(settings: Settings, client: AsyncClient) -> None:
    response = await client.get(f"{settings.API_V1_STR}/users/me")
    assert response.status_code == 404


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "client",
    [auth_data()],
    indirect=["client"],
)
async def test_get_user(settings: Settings, client: AsyncClient, db: DBType) -> None:
    await User.get_collection(db).insert_one(test_user.dict(by_alias=True))
    response = await client.get(f"{settings.API_V1_STR}/users/me")
    print(response.json())
    assert response.status_code == 200
    assert response.json() == test_user.dict(by_alias=True)
