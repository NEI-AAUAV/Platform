import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NoteSubject
from app.tests.conftest import SessionTesting

NOTES_SUBJECT = [
    {
        "paco_code": 2,
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "paco_code": 3,
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
        db.add(NoteSubject(**subj))
    db.commit()


def test_get_note_subject(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/subjects/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2  # created 2 note subjects
    for lst in data:
        assert "paco_code" in lst
        assert "name" in lst
        assert "year" in lst
        assert "semester" in lst
