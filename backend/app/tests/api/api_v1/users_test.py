import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Users
from app.tests.conftest import SessionTesting

USERS = [
    {   
        "id": 2,
        "name": 'Ze Pistolas',
        "full_name": 'Ze Pistolas Pistolas',
        "uu_email": 'pmapm@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": 'pedro_cv',
        "linkedin": 'pedro_linkedin',
        "git": 'pedro_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "id": 3,
        "name": "Francisco Abrantes",
        "full_name": "Francisco Miguel Abrantes",
        "uu_email": "eduardofernandes@ua.pt",
        "uu_yupi": 'x2x2',
        "curriculo": 'eduardo_cv',
        "linkedin": 'eduardo_linkedin',
        "git": 'eduardo_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    }
]

user =  {
  "name": "nome alterado",
  "full_name": "string",
  "uu_email": "string",
  "uu_yupi": "string",
  "curriculo": "string",
  "linkedin": "string",
  "git": "string",
  "permission": "DEFAULT",
  "created_at": "2022-10-02T21:31:48.217Z"
}

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for user in USERS:
        db.add(Users(**user))
    db.commit()

def test_get_users(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/users/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert "id" in data[0]
    assert "full_name" in data[0]

def test_get_user_by_id(client: TestClient) -> None:
    user_id = 2
    r = client.get(f"{settings.API_V1_STR}/users/{user_id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data
    assert data["id"] == user_id
    assert "full_name" in data

def test_get_inexistent_user_by_id(client: TestClient) -> None:
    inexistent_user_id = 10
    r = client.get(f"{settings.API_V1_STR}/users/{inexistent_user_id}")
    data = r.json()
    assert r.status_code == 200
    assert data == None

def test_create_user(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/users/", json=user)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data
    assert "full_name" in data

def test_update_user(client: TestClient) -> None:
    user_id = 2
    r = client.put(f"{settings.API_V1_STR}/users/{user_id}", json=user)
    data = r.json()
    print(data)
    assert r.status_code == 200
    assert data["id"] == user_id
    assert data["name"] == "nome alterado"

def test_update_inexistent_user(client: TestClient) -> None:
    inexistent_user_id = 10
    r = client.put(f"{settings.API_V1_STR}/users/{inexistent_user_id}", json=user)
    data = r.json()
    assert data == None
