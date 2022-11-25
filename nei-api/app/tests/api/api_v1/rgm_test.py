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
        "category": "pao",
        "mandate": 4,
        "file": "/nei.png"
    },
    {
        "id": 2,
        "category": "pao",
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for rgms in RGM:
        db.add(Rgm(**rgms))
    db.commit()

def test_category(client: TestClient) -> None:
    category = 'pao'
    r = client.get(f"{settings.API_V1_STR}/rgm/{category}")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        data2 = dict(RGM[i])
        file = data2.pop('file', None)
        assert data[i].items() >= data2.items()
        if file:
            assert data[i]['file'].endswith(file)


def test_bad_request(client: TestClient) -> None:
    category = 'p'
    r = client.get(f"{settings.API_V1_STR}/rgm/{category}")
    assert r.status_code == 400
