import pytest
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Note, Subject, Teacher, User
from app.tests.conftest import SessionTesting



SUBJECTS = [
    {
        "code": 1,
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "code": 2,
        "name": "random name",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    }
]

TEACHERS = [
    {
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
    {
        'name': 'TOS',
        'personal_page': 'personalpage_tos'
    }
]

NOTES = [
    {
        'year': 2020,
        'name': 'note name 0',
        'location': '/path/to/note/1',
        "summary": 1,
        "tests": 1,
        "bibliography": 1,
        "slides": 1,
        "exercises": 0,
        "projects": 0,
        "notebook": 1,
        "content": "content text bla bla bla bla bla",
        "created_at": datetime(2022, 8, 4),
        "size": 1,
    },
    {
        'year': 2021,
        'name': 'note name 1',
        'location': '/path/to/note/2',
        "summary": 1,
        "tests": 1,
        "bibliography": 0,
        "slides": 1,
        "exercises": 0,
        "projects": 0,
        "notebook": 1,
        "content": "content text bla bla bla bla bla",
        "created_at": datetime(2022, 8, 4),
        "size": 1,
    }
]

USERS = [
    {
        "name": 'Ze Pistolas',
        "surname": 'Pistolas',
        "email": 'zpp@ua.pt',
        "iupi": 'x1x1',
        "curriculum": 'ze_cv',
        "linkedin": 'ze_linkedin',
        "github": 'ze_git',
        "scopes": ['ADMIN'],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5)
    },
    {
        "name": "Francisco",
        "surname": "Miguel Abrantes",
        "email": "fma@ua.pt",
        "iupi": 'x2x2',
        "curriculum": 'francisco_cv',
        "linkedin": 'francisco_linkedin',
        "github": 'francisco_git',
        "scopes": ['MANAGER_NEI', 'MANAGER_TACAUA'],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5)
    }
]

note = {
    'year': 2020,
    'name': 'note name 0',
    'location': 'Aveiro',
    "summary": 1,
    "tests": 1,
    "bibliography": 1,
    "slides": 1,
    "exercises": 0,
    "projects": 0,
    "notebook": 1,
    "content": "content text bla bla bla bla bla",
    "created_at": "2022-10-02T21:31:48.217Z",
    "size": 1,
}

update_note = {
    "name": "string",
    "location": "string",
    "summary": 1,
    "tests": 1,
    "bibliography": 1,
    "slides": 1,
    "exercises": 0,
    "projects": 0,
    "notebook": 1,
    "content": "Note Alterada",
    "created_at": "2022-10-10T14:35:56.660Z",
    "size": 0,
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subject in SUBJECTS:
        db.add(Subject(**subject))
    for teacher in TEACHERS:
        db.add(Teacher(**teacher))
    for user in USERS:
        db.add(User(**user))
    db.commit()

    for note, sid, aid, tid in zip(
        NOTES,
        [s.code for s in db.query(Subject).all()],
        [a.id for a in db.query(User).all()],
        [t.id for t in db.query(Teacher).all()]
    ):
        db.add(Note(**note, subject_id=sid, author_id=aid, teacher_id=tid))
    db.commit()


def test_get_note(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/")
    data = r.json()
    assert r.status_code == 200
    assert "author" in data["items"][0]
    assert "teacher" in data["items"][0]
    assert "subject" in data["items"][0]
    assert "year" in data["items"][0]


def test_get_note_by_id(client: TestClient, db: SessionTesting) -> None:
    note_id = db.query(Note).first().id
    r = client.get(f"{settings.API_V1_STR}/note/{note_id}")
    data = r.json()
    assert r.status_code == 200
    assert "id" in data
    assert data["id"] == note_id


def test_get_inexistent_note_by_id(client: TestClient) -> None:
    inexistent_note_id = -1
    r = client.get(f"{settings.API_V1_STR}/note/{inexistent_note_id}")
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Invalid Note id"


def test_get_note_by_categories(client: TestClient) -> None:
    r = client.get(
        f"{settings.API_V1_STR}/note?category[]=bibliography&category[]=tests")
    assert r.status_code == 200
    data = r.json()
    assert data['total'] == len(data['items']) == 2
    assert all(i['bibliography'] or i['tests'] for i in data['items'])
    r = client.get(
        f"{settings.API_V1_STR}/note?category[]=slides&category[]=tests")
    assert r.status_code == 200
    data = r.json()
    assert data['total'] == len(data['items']) == 2
    assert all(i['slides'] or i['tests'] for i in data['items'])