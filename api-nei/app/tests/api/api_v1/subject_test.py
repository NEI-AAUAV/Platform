import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Subject
from app.tests.conftest import SessionTesting


SUBJECTS = [
    {
        "code": 2,
        "name": "random name 0",
        "curricular_year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
        "code": 3,
        "name": "random name",
        "curricular_year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    }
]

subject = {
    "name": "random name name",
    "curricular_year": 2021,
    "semester": 2,
    "short": "short",
    "discontinued": 1,
    "optional": 1
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in SUBJECTS:
        db.add(Subject(**subj))
    db.commit()


def test_get_subject(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/subject/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2  # created 2 note subjects
    for lst in data:
        assert "code" in lst
        assert "name" in lst
        assert "curricular_year" in lst
        assert "semester" in lst
