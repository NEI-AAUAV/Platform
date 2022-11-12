import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Redirect
from app.tests.conftest import SessionTesting


redirect = [
    {
        "id": 0,
        "alias": "Test1",
        "redirect": "redirecforTest1"
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for redirects in redirect:
        db.add(Redirect(**redirects))
    db.commit()

def test_get_redirect(db: SessionTesting, client: TestClient) -> None:
    redirectAlias = "Test1"
    r = client.get(f"{settings.API_V1_STR}/redirects/?alias={redirectAlias}")
    data = r.json()
    assert data["redirect"] == "redirecforTest1"

def test_redirect_error(client: TestClient) -> None:
    redirectAlias = "Test3"
    r = client.get(f"{settings.API_V1_STR}/redirects/?alias={redirectAlias}")
    data = r.json()
    assert r.status_code == 404