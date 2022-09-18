import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Competition
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/competition"

modality_data = {
    "year": 0,
    "frame": "Misto",
    "sport": "Atletismo",
}

competition_data = {
    "name": "string",
    "system": "Eliminação Direta",
    "rank_by": "Vitórias",
    "started": False,
    "public": False
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    modality = Modality(**modality_data)
    db.add(modality)
    db.commit()

    db.add(Competition(modality_id=modality.id, **competition_data))
    db.commit()


def test_create_competition(db: SessionTesting, client: TestClient) -> None:
    id = db.query(Modality).first().id
    r = client.post(URL_PREFIX, json={"modality_id": id, **competition_data},
                    allow_redirects=True)
    assert r.status_code == 201
    data = r.json()
    assert 'id' in data
    assert data.items() >= competition_data.items()


def test_remove_competition(db: SessionTesting, client: TestClient) -> None:
    competition = db.query(Competition).first()
    r = client.delete(f"{URL_PREFIX}/{competition.id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == competition.id
    modality = db.query(Modality).filter(
        Modality.id == data['modality_id']).first()
    assert len(modality.competitions) == 0
