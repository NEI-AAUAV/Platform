import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import NoteType
from app.tests.conftest import SessionTesting

NOTES_TYPES = [
    {
        "id": 2,
        "name": "name note type 0",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    },
    {
        "id": 3,
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

note_type = {
    "name": "name note type updated",
    "download_caption": "download_caption",
    "icon_display": 'display',
    "icon_download": 'download',
    "external": 1
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for subj in NOTES_TYPES:
        db.add(NoteType(**subj))
    db.commit()


def test_get_note_types(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/note/type/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2  # created 2 note subjects
    for lst in data:
        assert "id" in lst
        assert "name" in lst
        assert "download_caption" in lst
        assert "icon_download" in lst
