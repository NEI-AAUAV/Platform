import pytest
from typing import Any
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Rgm
from app.tests.conftest import SessionTesting


RGM = [
    {
        "id": 1,
        "categoria": "pao",
        "mandato": 4,
        "file": "https://nei.web.ua.pt/nei.png"
    },
    {
        "id": 2,
        "categoria": "pao",
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for rgms in RGM:
        db.add(Rgm(**rgms))
    db.commit()

def test_category(client: TestClient) -> None:
    categoria = 'pao'
    r = client.get(f"{settings.API_V1_STR}/rgm/{categoria}")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        assert data[i].items() >= RGM[i].items()

def test_bad_request(client: TestClient) -> None:
    categoria = 'p'
    r = client.get(f"{settings.API_V1_STR}/rgm/{categoria}")
    assert r.status_code == 400
