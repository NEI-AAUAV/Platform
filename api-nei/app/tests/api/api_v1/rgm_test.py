import pytest
from typing import Any
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Rgm, RgmMandate
from app.tests.conftest import SessionTesting


RGM = [
    {
        "id": 1,
        "category": "PAO",
        "mandate": "2020/21",
        "title": "RGM 2020/21",
        "file": "/nei.png",
        "date": datetime(2021, 1, 1).isoformat(),
    },
    {
        "id": 2,
        "category": "PAO",
        "mandate": "2020",
        "title": "RGM 2020",
        "file": "/rgm2020.png",
        "date": datetime(2020, 1, 1).isoformat(),
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    labels = {r["mandate"]: RgmMandate(label=r["mandate"]) for r in RGM}
    db.add_all(labels.values())
    db.flush()
    for rgms in RGM:
        db.add(Rgm(mandate_id=labels[rgms["mandate"]].id, **rgms))
    db.commit()


def test_category(client: TestClient) -> None:
    category = "pao"
    r = client.get(f"{settings.API_V1_STR}/rgm/?category={category}")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        data2 = dict(RGM[i])
        file = data2.pop("file", None)
        print(data[i], data2)
        assert data[i].items() >= data2.items()
        if file:
            assert data[i]["file"].endswith(file)


def test_bad_request(client: TestClient) -> None:
    category = "p"
    r = client.get(f"{settings.API_V1_STR}/rgm/?category={category}")
    assert r.status_code == 400
