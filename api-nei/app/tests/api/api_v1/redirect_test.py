import pytest
from typing import Any

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Redirect
from app.tests.conftest import SessionTesting


redirects = [
    {
        "id": 0,
        "alias": "Test1",
        "redirect": "redirecforTest1"
    }
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for redirect in redirects:
        db.add(Redirect(**redirect))
    db.commit()


def test_get_redirect(client: TestClient) -> None:
    redirectAlias = "Test1"
    r = client.get(f"{settings.API_V1_STR}/redirect/?alias={redirectAlias}")
    data = r.json()
    assert data["redirect"] == "static/nei/redirecforTest1"


def test_redirect_error(client: TestClient) -> None:
    redirectAlias = "Test3"
    r = client.get(f"{settings.API_V1_STR}/redirect/?alias={redirectAlias}")
    data = r.json()
    assert r.status_code == 404
