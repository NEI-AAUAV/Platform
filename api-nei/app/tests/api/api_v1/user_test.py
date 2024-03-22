import pytest
from typing import List
from datetime import datetime

from fastapi.testclient import TestClient

from app.models import User
from app.core.config import settings
from app.schemas.user.user import ScopeEnum
from app.tests.conftest import SessionTesting

from ._utils import auth_data


USERS = [
    {
        "id": 2,
        "name": "Ze Pistolas",
        "surname": "Pistolas",
        "iupi": "x1x1",
        "curriculum": "ze_cv",
        "linkedin": "https://ze_linkedin",
        "github": "https://ze_git",
        "scopes": [ScopeEnum.ADMIN],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5),
    },
    {
        "id": 3,
        "name": "Francisco",
        "surname": "Abrantes",
        "iupi": "x2x2",
        "curriculum": "francisco_cv",
        "linkedin": "http://francisco_linkedin",
        "github": "https://francisco_git",
        "scopes": [],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5),
    },
]

user = {
    "name": "nome alterado",
    "surname": "string",
    "curriculum": "string",
    "linkedin": "https://string",
    "github": "https://string",
    "email": "test@dev.dev",
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for user in USERS:
        db.add(User(**user))
    db.commit()


manager_not_present = ["iupi", "scopes"]
logged_in_not_present = [
    "nmec",
    "created_at",
    "updated_at",
    "matriculation",
] + manager_not_present


@pytest.mark.parametrize(
    "client,status_code,not_present",
    [
        (None, 401, []),
        (auth_data(), 403, []),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 200, manager_not_present),
        (auth_data(scopes=[ScopeEnum.ADMIN]), 200, []),
    ],
    indirect=["client"],
)
def test_get_users(
    client: TestClient, status_code: int, not_present: List[str]
) -> None:
    r = client.get(f"{settings.API_V1_STR}/user/")
    data = r.json()
    assert r.status_code == status_code
    if r.is_error:
        return
    assert len(data) == 2
    assert "id" in data[0]
    assert "surname" in data[0]
    for field in not_present:
        assert field not in data[0]


@pytest.mark.parametrize(
    "client,not_present",
    [
        (None, ["birthday"] + logged_in_not_present),
        (auth_data(), logged_in_not_present),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), manager_not_present),
        (auth_data(scopes=[ScopeEnum.ADMIN]), []),
    ],
    indirect=["client"],
)
def test_get_user_by_id(client: TestClient, not_present: List[str]) -> None:
    user_id = 2
    r = client.get(f"{settings.API_V1_STR}/user/{user_id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data
    assert data["id"] == user_id
    assert "surname" in data
    for field in not_present:
        assert field not in data


def test_get_inexistent_user_by_id(client: TestClient) -> None:
    inexistent_user_id = 10
    r = client.get(f"{settings.API_V1_STR}/user/{inexistent_user_id}")
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "User not found."


@pytest.mark.parametrize(
    "client,status_code",
    [
        (None, 401),
        (auth_data(), 403),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 403),
        (auth_data(scopes=[ScopeEnum.ADMIN]), 201),
    ],
    indirect=["client"],
)
def test_create_user(client: TestClient, status_code: int) -> None:
    r = client.post(f"{settings.API_V1_STR}/user/", json=user)
    data = r.json()
    assert r.status_code == status_code
    if r.is_error:
        return
    assert "id" in data
    assert "surname" in data


@pytest.mark.parametrize(
    "client,status_code",
    [
        (None, 401),
        (auth_data(), 403),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 200),
    ],
    indirect=["client"],
)
def test_update_user(client: TestClient, status_code: int) -> None:
    user_under_test = USERS[0]
    user_id = user_under_test["id"]
    assert user_under_test["name"] != user["name"]

    r = client.put(f"{settings.API_V1_STR}/user/{user_id}", json=user)
    data = r.json()
    assert r.status_code == status_code
    if r.is_error:
        return
    assert data["id"] == user_id
    assert data["name"] == "nome alterado"


@pytest.mark.parametrize(
    "client,status_code",
    [
        (None, 401),
        (auth_data(), 403),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 404),
    ],
    indirect=["client"],
)
def test_update_inexistent_user(client: TestClient, status_code: int) -> None:
    inexistent_user_id = 0
    r = client.put(
        f"{settings.API_V1_STR}/user/{inexistent_user_id}", json={"name": "Teste"}
    )
    assert r.status_code == status_code


@pytest.mark.parametrize(
    "client,status_code",
    [
        (auth_data(), 403),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 200),
    ],
    indirect=["client"],
)
def test_update_protected_fields_manager(client: TestClient, status_code: int) -> None:
    user_id = USERS[0]["id"]
    r = client.put(f"{settings.API_V1_STR}/user/{user_id}", json={"nmec": "111"})
    assert r.status_code == status_code


@pytest.mark.parametrize(
    "client,status_code",
    [
        (auth_data(), 403),
        (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 403),
        (auth_data(scopes=[ScopeEnum.ADMIN]), 200),
    ],
    indirect=["client"],
)
def test_update_protected_fields_admin(client: TestClient, status_code: int) -> None:
    user_id = USERS[0]["id"]
    r = client.put(f"{settings.API_V1_STR}/user/{user_id}", json={"scopes": ["test"]})
    assert r.status_code == status_code
    r = client.put(f"{settings.API_V1_STR}/user/{user_id}", json={"iupi": "test"})
    assert r.status_code == status_code
