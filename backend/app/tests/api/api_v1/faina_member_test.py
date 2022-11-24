from datetime import datetime
import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import FainaMember, FainaRoles, Faina, Users
from app.tests.conftest import SessionTesting


user = [
    {
        "name": "Eduardo",
        "full_name": "Eduardo Rocha Fernandes",
        "uu_email": "eduardofernandes@ua.pt",
        "uu_yupi": 'x2x2',
        "curriculo": 'eduardo_cv',
        "linkedin": 'eduardo_linkedin',
        "git": 'eduardo_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "name": 'Pedro Monteiro',
        "full_name": 'Pedro Miguel Afonso de Pina Monteiro',
        "uu_email": 'pmapm@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": 'pedro_cv',
        "linkedin": 'pedro_linkedin',
        "git": 'pedro_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "name": 'Name Test',
        "full_name": 'Full Name Test',
        "uu_email": 'test@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": '',
        "linkedin": '',
        "git": '',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 8)
    }
]

fainas = [
    {
        "imagem" : "imagem_url",
        "anoLetivo": "2020/2021"
    },
    {
        "imagem" : "image1",
        "anoLetivo": "2019/2020"
    }
]

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

faina_member = [
    {
        "member_id": 0,
        "mandato_id": 0,
        "role_id": 0
    },
    {
        "member_id" : 1,
        "mandato_id" : 1,
        "role_id": 1
    },
    {
        "member_id" : 2,
        "mandato_id" : 0,
        "role_id" : 1
    }
]

update = {
    "member_id": 0,
    "mandato_id":1,
    "role_id" : 1
}

bad_faina_member = {
    "member_id": 2,
    "mandato_id" : 1
}

bad_faina_member_wrong_user_id = {
    "member_id" : 3,
    "mandato_id" : 0,
    "role_id" : 1
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    db.add(Users(id=0, **user[0]))
    db.add(Users(id=1, **user[1]))
    db.add(Users(id=2, **user[2]))
    db.add(Faina(mandato=0, **fainas[0]))
    db.add(Faina(mandato=1, **fainas[1]))
    db.add(FainaRoles(id=0, **faina_roles[0]))
    db.add(FainaRoles(id=1, **faina_roles[1]))
    db.add(FainaMember(id=0, **faina_member[0]))
    db.add(FainaMember(**faina_member[1]))
    db.commit()


def test_get_faina_member(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/faina/member/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert "id" in data[0]

def test_get_faina_member_by_id(client: TestClient) -> None:
    id=0
    r = client.get(f"{settings.API_V1_STR}/faina/member/{id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data


def test_create_faina_member(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/member/", json=faina_member[2])
    data = r.json()
    assert r.status_code == 201
    assert len(data) >= len(faina_member[2])
    assert 'id' in data


def test_create_faina_member_with_missing_field(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/member/", json=bad_faina_member)
    data = r.json()
    assert r.status_code == 422
    assert data["detail"][0]["loc"] == ['body', 'role_id']
    assert data["detail"][0]["msg"] == "field required"

def test_create_faina_member_with_wrong_user_id(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/member/", json=bad_faina_member_wrong_user_id)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "User Not Found"

def test_update_faina_member(client: TestClient) -> None:
    id = 0
    r = client.put(f"{settings.API_V1_STR}/faina/member/{id}", json=update)
    data = r.json()
    assert r.status_code == 200
    assert data.items() >= update.items()
    assert data["id"] == id

def test_update_inexistent_faina_member(client: TestClient) -> None:
    id = 10
    r = client.put(f"{settings.API_V1_STR}/faina/member/{id}", json=update)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Faina Member Not Found"