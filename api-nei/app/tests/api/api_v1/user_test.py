import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import User
from app.tests.conftest import SessionTesting


USERS = [
    {
        "id": 2,
        "name": 'Ze Pistolas',
        "surname": 'Pistolas',
        "email": 'zpp@ua.pt',
        "iupi": 'x1x1',
        "curriculum": 'ze_cv',
        "linkedin": 'ze_linkedin',
        "github": 'ze_git',
        "scopes": ['ADMIN'],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5)
    },
    {
        "id": 3,
        "name": "Francisco",
        "surname": "Abrantes",
        "email": "fma@ua.pt",
        "iupi": 'x2x2',
        "curriculum": 'francisco_cv',
        "linkedin": 'francisco_linkedin',
        "github": 'francisco_git',
        "scopes": [],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5)
    }
]

user = {
    "name": "nome alterado",
    "surname": "string",
    "email": "string",
    "iupi": "string",
    "curriculum": "string",
    "linkedin": "string",
    "github": "string",
    "scopes": [],
    "created_at": "2022-10-02T21:31:48.217Z"
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for user in USERS:
        db.add(User(**user))
    db.commit()


@pytest.mark.skip(reason="Authorization required")
def test_get_users(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert "id" in data[0]
    assert "surname" in data[0]


def test_get_user_by_id(client: TestClient) -> None:
    user_id = 2
    r = client.get(f"{settings.API_V1_STR}/user/{user_id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data
    assert data["id"] == user_id
    assert "surname" in data


def test_get_inexistent_user_by_id(client: TestClient) -> None:
    inexistent_user_id = 10
    r = client.get(f"{settings.API_V1_STR}/user/{inexistent_user_id}")
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Invalid User id"


@pytest.mark.skip(reason="Test aftwards when login is implemented")
def test_create_user(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/user/", json=user)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data
    assert "surname" in data


@pytest.mark.skip(reason="No way of currently testing this")
def test_update_user(client: TestClient) -> None:
    user_id = 2
    r = client.put(f"{settings.API_V1_STR}/user/{user_id}", json=user)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == user_id
    assert data["name"] == "nome alterado"


def test_update_inexistent_user(client: TestClient) -> None:
    inexistent_user_id = 0
    r = client.put(
        f"{settings.API_V1_STR}/user/{inexistent_user_id}", json={'name': 'Teste'})
    data = r.json()
    print(data)
    assert r.status_code == 404
    assert data["detail"] == "Invalid User id"
