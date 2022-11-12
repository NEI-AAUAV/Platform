import re
import pytest
from typing import Any
from datetime import datetime, date

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import History
from app.tests.conftest import SessionTesting

HISTORY = [
    {
        "moment": date(2022,1,2).isoformat(),
        "title": "TituloHistory",
        "body": "Texto muito interessante",
        "image": "https://nei.web.ua.pt/nei.png"
    },
    {
        "moment": date(1993,1,2).isoformat(),
        "title": "TituloHistory2",
        "body": "Texto muito pouco interessante"
    },
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for hist in HISTORY:
        db.add(History(**hist))
    db.commit()

def test_elements(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        assert data[i].items() >= HISTORY[i].items()

def test_date(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert re.match("([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])",el["moment"])

def test_text(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert len(el["title"]) > 0 and len(el["body"]) > 0

def test_img(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        if HISTORY[i].get("image") != None:
            assert data[i]["image"]#Checkar se caso haja imagem, existe string