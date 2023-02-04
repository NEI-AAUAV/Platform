import pytest
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Note, NoteThank, NoteType, NoteSchoolYear, NoteSubject, NoteTeacher, User
from app.tests.conftest import SessionTesting

NOTES_SCHOOL_YEAR = [
    {
        "year_begin": 2020,
        "year_end": 2023
    },
    {
        "year_begin": 2020,
        "year_end": 2023
    }
]

NOTES_SUBJECT = [
    {
        "paco_code": 1,
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "paco_code": 2,
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
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
    {
        'name': 'TOS',
        'personal_page': 'personalpage_tos'
    }
]

NOTES_THANKS = [
    {
        "note_personal_page": "http://my-personal-page.com"
    },
    {
        "note_personal_page": "http://my-personal-page.com"
    }
]

NOTES_TYPES = [
    {
        "name": "name note type 0",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    },
    {
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

NOTES = [
    {
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
        "full_name": 'Ze Pistolas Pistolas',
        "uu_email": 'zpp@ua.pt',
        "uu_iupi": 'x1x1',
        "curriculo": 'ze_cv',
        "linkedin": 'ze_linkedin',
        "git": 'ze_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "name": "Francisco Abrantes",
        "full_name": "Francisco Miguel Abrantes",
        "uu_email": "fma@ua.pt",
        "uu_iupi": 'x2x2',
        "curriculo": 'francisco_cv',
        "linkedin": 'francisco_linkedin',
        "git": 'francisco_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    }
]

note = {
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

    for subj in NOTES_SUBJECT:
        db.add(NoteSubject(**subj))
    for type in NOTES_TYPES:
        db.add(NoteType(**type))
    for year in NOTES_SCHOOL_YEAR:
        db.add(NoteSchoolYear(**year))
    for teacher in NOTES_TEACHERS:
        db.add(NoteTeacher(**teacher))
    for user in USERS:
        db.add(User(**user))
    db.commit()

    for note, thanks, sid, aid, yid, tid, tyid in zip(
        NOTES,
        NOTES_THANKS,
        [s.paco_code for s in db.query(NoteSubject).all()],
        [a.id for a in db.query(User).all()],
        [y.id for y in db.query(NoteSchoolYear).all()],
        [t.id for t in db.query(NoteTeacher).all()],
        [ty.id for ty in db.query(NoteType).all()],
    ):
        db.add(Note(**note, subject_id=sid, author_id=aid,
               school_year_id=yid, teacher_id=tid, type_id=tyid))
        db.add(NoteThank(**thanks, author_id=aid))
    db.commit()


def test_get_note(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/")
    data = r.json()
    assert r.status_code == 200
    assert "author" in data["items"][0]
    assert "teacher" in data["items"][0]
    assert "subject" in data["items"][0]
    assert "school_year" in data["items"][0]


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
