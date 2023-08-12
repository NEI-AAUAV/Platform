import json
import pytest
from typing import Any
from io import BytesIO
from PIL import Image

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Competition
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/modalities"

modality_data = {
    "year": 0,
    "type": "Coletiva",
    "frame": "Masculino",
    "sport": "Voleibol 4x4",
}

competition_data = {
    "name": "string",
    "started": False,
    "public": False,
    "_metadata": {
        "rank_by": "Vitórias",
        "system": "Eliminação Direta",
        "third_place_match": False
    }
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    modality = Modality(**modality_data)
    db.add(modality)
    db.commit()
    db.refresh(modality)

    db.add(Competition(modality_id=modality.id, **competition_data))
    db.commit()


def test_get_multi_modality(client: TestClient) -> None:
    r = client.get(URL_PREFIX)
    assert r.status_code == 200
    data = r.json()
    assert 'modalities' in data
    assert len(data['modalities']) == 1
    assert 'id' in data['modalities'][0]
    assert 'competitions' not in data['modalities'][0]


def test_get_modality(db: SessionTesting, client: TestClient) -> None:
    id = db.query(Modality).first().id
    r = client.get(f"{URL_PREFIX}/{id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == id
    assert 'competitions' in data
    assert len(data['competitions']) == 1


def test_get_inexistent_modality(client: TestClient) -> None:
    id = 99
    r = client.get(f"{URL_PREFIX}/{id}")
    assert r.status_code == 404
    data = r.json()
    assert data["detail"] == "Modality Not Found"


def test_create_modality(client: TestClient) -> None:
    
    r = client.post(URL_PREFIX, json=modality_data,
                    allow_redirects=True)
    assert r.status_code == 201
    data = r.json()
    assert 'id' in data
    assert 'competitions' in data
    assert len(data['competitions']) == 0
    assert data.items() >= modality_data.items()


def test_update_modality(db: SessionTesting, client: TestClient) -> None:
    modality = db.query(Modality).first()
    modality_partial_data = {
        "year": 1,
        "frame": "Feminino",
        "sport": "Andebol",
    }
    r = client.put(f"{URL_PREFIX}/{modality.id}",
                   json=modality_partial_data,
                   allow_redirects=True)
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == modality.id
    assert 'competitions' in data
    assert not data.items() >= modality_data.items()
    assert data.items() >= modality_partial_data.items()


def test_remove_modality(db: SessionTesting, client: TestClient) -> None:
    modality = db.query(Modality).first()
    r = client.delete(f"{URL_PREFIX}/{modality.id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == modality.id
    assert 'competitions' in data
    assert len(data['competitions']) == 1
    competitions = db.query(Competition).filter(
        Competition.modality_id == modality.id).all()
    assert len(competitions) == 0
