import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NotesSchoolYear
from app.tests.conftest import SessionTesting

NOTES_SCHOOL_YEAR = [
    {
        "id": 2,
        "year_begin": 2020,
        "year_end": 2023
    },
    {
        "id": 3,
        "year_begin": 2020,
        "year_end": 2023
    }
]

note_year = {
    "year_begin": 2079,
    "year_end": 2090
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
    assert len(data) == 2  # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "year_begin" in lst
        assert "year_end" in lst
