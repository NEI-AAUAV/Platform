import pytest
import os
from io import BytesIO
from datetime import date, datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Notes, NotesThanks, NotesTypes, NotesSchoolYear, NotesSubject, NotesTeachers, Users
from app.tests.conftest import SessionTesting

NOTES_SCHOOL_YEAR = [
    {   
        "id":1,
        "yearBegin": 2020,
        "yearEnd": 2023
    },
        {
        "id":2,
        "yearBegin": 2020,
        "yearEnd": 2023
    }
]

NOTES_SUBJECT = [
        {
        "paco_code":1,
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "paco_code":2,
        "name": "random name",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
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

NOTES_THANKS = [
        {
        "id":1,
        'author_id': 1,
        "notes_personal_page": "very much thanks"
    },
    {
        "id":2,
        'author_id': 1,
        "notes_personal_page": "very much thanks"
    }
]

NOTES_TYPES = [
        {
        "id":1,
        "name": "name note type 0",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    },
    {
        "id":2,
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

NOTES = [
    {
        "id":2,
        'name': 'note name 0',
        'location': 'Aveiro',
        "subject_id": 1,
        "author_id": 1,
        "school_year_id": 1,
        "teacher_id": 1,
        "summary": 1,
        "tests": 1,
        "bibliography": 1,
        "slides": 1,
        "exercises": 0,
        "projects": 0,
        "notebook": 1,
        "content": "content text bla bla bla bla bla",
        "created_at": datetime(2022, 8, 4),
        "type_id": 1,
        "size": 1,
        "category": "xxxxxx"
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

note = {
    "id": 3,
        'name': 'note name 0',
        'location': 'Aveiro',
        "subject_id": 1,
        "author_id": 1,
        "school_year_id": 1,
        "teacher_id": 1,
        "summary": 1,
        "tests": 1,
        "bibliography": 1,
        "slides": 1,
        "exercises": 0,
        "projects": 0,
        "notebook": 1,
        "content": "content text bla bla bla bla bla",
       "created_at": "2022-10-02T21:31:48.217Z",
        "type_id": 1,
        "size": 1,
        "category": "xxxxxx"
}

update_note = {
  "name": "string",
  "location": "string",
  "subject_id": 1,
    "author_id": 1,
    "school_year_id": 1,
    "teacher_id": 1,
    "summary": 1,
    "tests": 1,
    "bibliography": 1,
    "slides": 1,
    "exercises": 0,
    "projects": 0,
    "notebook": 1,
  "content": "Note Alterada",
  "created_at": "2022-10-10T14:35:56.660Z",
  "type_id": 1,
  "size": 0,
  "category": "string"
}

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_SUBJECT:
        db.add(NotesSubject(**subj))
    for type in NOTES_TYPES:
        db.add(NotesTypes(**type))
    for year in NOTES_SCHOOL_YEAR: 
        db.add(NotesSchoolYear(**year))
    for teacher in NOTES_TEACHERS: 
        db.add(NotesTeachers(**teacher))
    for thanks in NOTES_THANKS:
        db.add(NotesThanks(**thanks))
    for note in NOTES:
        db.add(Notes(**note))
    for user in USERS:
        db.add(Users(**user))
    db.commit()

def test_get_notes(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/notes/")
    data = r.json()
    assert r.status_code == 200
    assert "author" in data["items"][0]
    assert "teacher" in data["items"][0]
    assert "subject" in data["items"][0]
    assert "school_year" in data["items"][0]

def test_get_note_by_id(client: TestClient) -> None:
    note_id = 2
    r = client.get(f"{settings.API_V1_STR}/notes/{note_id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data
    assert data["id"] == note_id

def test_get_inexistent_note_by_id(client: TestClient) -> None:
    inexistent_note_id = -1
    r = client.get(f"{settings.API_V1_STR}/notes/{inexistent_note_id}")
    data = r.json()
    assert r.status_code == 200
    assert data == None

def test_create_note(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/notes/", json=note)
    data = r.json()
    assert r.status_code == 201
    assert "id" in data
    assert "location" in data

def test_update_note(client: TestClient) -> None:
    note_id = 2
    r = client.put(f"{settings.API_V1_STR}/notes/{note_id}", json=update_note)
    data = r.json()
    assert r.status_code == 200
    assert data["id"] == note_id
    assert data["content"] == update_note["content"]

def test_update_inexistent_note(client: TestClient) -> None:
    inexistent_note_id = -1
    r = client.put(f"{settings.API_V1_STR}/notes/{inexistent_note_id}", json=update_note)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Invalid Note id"