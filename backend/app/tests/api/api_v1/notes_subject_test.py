import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesSubject
from app.tests.conftest import SessionTesting

NOTES_SUBJECT = [
        {
        "paco_code":2,
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "paco_code":3,
        "name": "random name",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    }
]

note_subject = {
        "name": "random name name",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    }

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_SUBJECT:
        db.add(NotesSubject(**subj))
    db.commit()

def test_get_notes_subject(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/subjects/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2 # created 2 note subjects
    for lst in data:
        assert "paco_code" in lst
        assert "name" in lst
        assert "year" in lst
        assert "semester" in lst

def test_create_note_subject(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/subjects/", json=note_subject)
    data = r.json()
    assert r.status_code == 201
    assert "paco_code" in data

def test_update_note_subject(client: TestClient) -> None:
    paco_code = 2
    r = client.put(f"{settings.API_V1_STR}/notes/subjects/{paco_code}", json=note_subject)
    data = r.json()
    assert r.status_code == 200
    assert data["paco_code"] == 2
    assert data["name"] == note_subject["name"]

def test_update_inexistent_note_subject(client: TestClient) -> None:
    inexistent_paco_code = -1
    r = client.put(f"{settings.API_V1_STR}/notes/subjects/{inexistent_paco_code}", json=note_subject)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Invalid Note Subject id"