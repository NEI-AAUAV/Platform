import re
import pytest
from typing import Any
from datetime import datetime, date

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Merchandisings
from app.tests.conftest import SessionTesting

MERCHANDISINGS = [
    {
        "id": 1,
        "name": "Cat123456",
        "image": "https://nei.web.ua.pt/nei.png",
        "price": 4,
        "number_of_items": 5
    },
    {
        "id": 2,
        "name": "Cat123456",
        "image": "",
        "price": 4,
        "number_of_items": 5
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for merch in MERCHANDISINGS:
        db.add(Merchandisings(**merch))
    db.commit()

def test_elements(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/merch")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        assert data[i].items() >= MERCHANDISINGS[i].items()
    
def test_text(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/merch")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert len(el["name"]) > 0