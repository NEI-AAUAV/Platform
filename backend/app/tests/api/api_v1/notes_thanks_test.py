import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesThanks, NotesTeachers, Users
from app.tests.conftest import SessionTesting

NOTES_THANKS = [
        {
        "id":2,
        'author_id': 1,
        "notes_personal_page": "very much thanks"
    },
    {
        "id":3,
        'author_id': 2,
        "notes_personal_page": "very much thanks"
    }
]

NOTES_TEACHERS = [
    {
        "id":1,
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
        {
        "id":2,
        'name': 'TOS',
        'personal_page': 'personalpage_tos'
    }
]

USERS = [
    {   
        "id": 1,
        "name": 'Ze Pistolas',
        "full_name": 'Ze Pistolas Pistolas',
        "uu_email": 'zpp@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": 'ze_cv',
        "linkedin": 'ze_linkedin',
        "git": 'ze_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "id": 2,
        "name": "Francisco Abrantes",
        "full_name": "Francisco Miguel Abrantes",
        "uu_email": "fma@ua.pt",
        "uu_yupi": 'x2x2',
        "curriculo": 'francisco_cv',
        "linkedin": 'francisco_linkedin',
        "git": 'francisco_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    }
]

note_thanks =     {
        "id":5,
        'author_id': 1,
        "notes_personal_page": "very much thanks"
    }

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_THANKS:
        db.add(NotesThanks(**subj))
    for subj in NOTES_TEACHERS:
        db.add(NotesTeachers(**subj))
    for subj in USERS:
        db.add(Users(**subj))
    db.commit()

def test_get_notes_thanks(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/thanks/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2 # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "author_id" in lst
        assert "notes_personal_page" in lst

def test_create_note_thanks(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/thanks/", json=note_thanks)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data

def test_update_note_thanks(client: TestClient) -> None:
    id = 3
    r = client.put(f"{settings.API_V1_STR}/notes/thanks/{id}", json=note_thanks)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == id
    assert data["notes_personal_page"] == note_thanks["notes_personal_page"]

def test_update_inexistent_note_thanks(client: TestClient) -> None:
    inexistent_id = -1
    r = client.put(f"{settings.API_V1_STR}/notes/thanks/{inexistent_id}", json=note_thanks)
    data = r.json()
    assert data == None