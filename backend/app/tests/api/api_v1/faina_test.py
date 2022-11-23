import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Faina
from app.tests.conftest import SessionTesting


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

more_fainas = [
    {
        "imagem" : "image2",
        "anoLetivo": "2018/2019"
    }
]

faina =     {
        "imagem" : "imagem_url",
        "anoLetivo": "2021/2022"
    }

update = {
    "imagem": "string",
    "anoLetivo": "string"
}

bad_faina = {
    "imagem":"ola"
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    db.add(Faina(mandato=0, **fainas[1]))
    db.add(Faina(**fainas[0]))
    db.commit()


def test_get_faina(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/faina/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert "mandato" in data[0]

def test_get_all_fainas(db: SessionTesting, client: TestClient) -> None:
    for fn in more_fainas:
        db.add(Faina(**fn))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/faina/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 3


def test_create_faina(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/", json=faina)
    data = r.json()
    assert r.status_code == 201
    assert data.items() >= faina.items()
    assert 'mandato' in data

def test_create_faina_with_missing_field(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/faina/", json=bad_faina)
    data = r.json()
    assert r.status_code == 422
    assert data["detail"][0]["loc"] == ['body', 'anoLetivo']
    assert data["detail"][0]["msg"] == "field required"

def test_update_faina(client: TestClient) -> None:
    mandato = 0
    r = client.put(f"{settings.API_V1_STR}/faina/{mandato}", json=update)
    data = r.json()
    assert r.status_code == 200
    assert data.items() >= update.items()
    assert data["mandato"] == mandato

def test_update_inexistent_faina(client: TestClient) -> None:
    mandato = 10
    r = client.put(f"{settings.API_V1_STR}/faina/{mandato}", json=update)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Faina Not Found"