import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesTeachers
from app.tests.conftest import SessionTesting

NOTES_TEACHERS = [
    {
        "id":2,
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
        {
        "id":3,
        'name': 'TOS',
        'personal_page': 'personalpage_tos'
    }
]

note_teacher = {
        'name': 'PT',
        'personal_page': 'personalpage_pt'
    }

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_TEACHERS:
        db.add(NotesTeachers(**subj))
    db.commit()

def test_get_notes_teachers(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/teachers/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2 # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "name" in lst
        assert "personal_page" in lst

def test_create_note_teachers(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/teachers/", json=note_teacher)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data

def test_update_note_teachers(client: TestClient) -> None:
    note_id = 2
    r = client.put(f"{settings.API_V1_STR}/notes/teachers/{note_id}", json=note_teacher)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == note_id
    assert data["personal_page"] == note_teacher["personal_page"]

def test_update_inexistent_note_teachers(client: TestClient) -> None:
    inexistent_id = -1
    r = client.put(f"{settings.API_V1_STR}/notes/teachers/{inexistent_id}", json=note_teacher)
    data = r.json()
    assert data == None