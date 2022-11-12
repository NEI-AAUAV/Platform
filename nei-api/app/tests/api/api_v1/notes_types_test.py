import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesTypes
from app.tests.conftest import SessionTesting

NOTES_TYPES = [
        {
        "id":2,
        "name": "name note type 0",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    },
    {
        "id":3,
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

note_type = {
        "name": "name note type updated",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_TYPES:
        db.add(NotesTypes(**subj))
    db.commit()

def test_get_notes_types(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/types/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2 # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "name" in lst
        assert "download_caption" in lst
        assert "icon_download" in lst

def test_create_note_type(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/types/", json=note_type)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data

def test_update_note_types(client: TestClient) -> None:
    note_id = 2
    r = client.put(f"{settings.API_V1_STR}/notes/types/{note_id}", json=note_type)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == note_id
    assert data["name"] == note_type["name"]

def test_update_inexistent_note_types(client: TestClient) -> None:
    inexistent_id = -1
    r = client.put(f"{settings.API_V1_STR}/notes/types/{inexistent_id}", json=note_type)
    assert r.status_code == 404
    data = r.json()
    assert data["detail"] == "Invalid Note Type id"