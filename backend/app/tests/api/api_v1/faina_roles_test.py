import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import FainaRoles
from app.tests.conftest import SessionTesting


faina_roles = [
    {
        "name" : "Marnoto",
        "weight": "4"
    },
    {
        "name" : "Moça",
        "weight": "3"
    }
]

faina_role = {
    "name" : "Mestre",
    "weight": "5"
}

bad_faina_role = {
    "weight":"10"
}

update = {
    "name":"Salineira",
    "weight":"4"
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""
    db.add(FainaRoles(id=0, **faina_roles[0]))
    db.add(FainaRoles(**faina_roles[1]))
    db.commit()


def test_get_all_faina_roles(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/faina/roles/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert "id" in data[0]


def test_get_faina_role_by_id(db: SessionTesting, client: TestClient) -> None:
    id=0
    r = client.get(f"{settings.API_V1_STR}/faina/roles/{id}")
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == 0

def test_get_unexistent_faina_role_by_id(db: SessionTesting, client: TestClient) -> None:
    id=10
    r = client.get(f"{settings.API_V1_STR}/faina/roles/{id}")
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Faina Role Not Found"


def test_create_faina_role(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/roles/", json=faina_role)
    data = r.json()
    assert r.status_code == 201
    assert len(data) >= len(faina_role)
    assert 'id' in data


def test_create_faina_role_with_missing_field(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/roles/", json=bad_faina_role)
    data = r.json()
    assert r.status_code == 422
    assert data["detail"][0]["loc"] == ['body', 'name']
    assert data["detail"][0]["msg"] == "field required"


def test_update_faina_role(client: TestClient) -> None:
    id = 0
    r = client.put(f"{settings.API_V1_STR}/faina/roles/{id}", json=update)
    data = r.json()
    assert r.status_code == 200
    assert len(data) >= len(update)
    assert data["id"] == id


def test_update_inexistent_faina_role(client: TestClient) -> None:
    id = 10
    r = client.put(f"{settings.API_V1_STR}/faina/roles/{id}", json=update)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Faina Role Not Found"