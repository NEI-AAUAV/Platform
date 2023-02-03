import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NoteTeacher
from app.tests.conftest import SessionTesting

NOTES_TEACHERS = [
    {
        "id": 2,
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
    {
        "id": 3,
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
        db.add(NoteTeacher(**subj))
    db.commit()


def test_get_note_teacher(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/teachers/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2  # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "name" in lst
        assert "personal_page" in lst
