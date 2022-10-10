import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesSchoolYear
from app.tests.conftest import SessionTesting

NOTES_SCHOOL_YEAR = [
    {   
        "id":2,
        "yearBegin": 2020,
        "yearEnd": 2023
    },
        {
        "id":3,
        "yearBegin": 2020,
        "yearEnd": 2023
    }
]

note_year =         {
        "yearBegin": 2079,
        "yearEnd": 2090
    }

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_SCHOOL_YEAR:
        db.add(NotesSchoolYear(**subj))
    db.commit()

def test_get_notes_year(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/years/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2 # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "yearBegin" in lst
        assert "yearEnd" in lst

def test_create_note_year(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/years/", json=note_year)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data

def test_update_note_year(client: TestClient) -> None:
    id = 3
    r = client.put(f"{settings.API_V1_STR}/notes/years/{id}", json=note_year)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == id
    assert data["yearBegin"] == note_year["yearBegin"]
    assert data["yearEnd"] == note_year["yearEnd"]

def test_update_inexistent_note_year(client: TestClient) -> None:
    id = -1
    r = client.put(f"{settings.API_V1_STR}/notes/years/{id}", json=note_year)
    data = r.json()
    assert data == None