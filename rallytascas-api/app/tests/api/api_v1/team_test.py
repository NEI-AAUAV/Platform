import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models.team import Team
from app.tests.conftest import SessionTesting

team = [
    {
        "id": 0,
        "name": "Test1",
        "scores": [],
        "times": []
    },
    {
        "id": 1,
        "name": "Test2",
        "scores": [],
        "times": []
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for teams in team:
        db.add(Team(**teams))
    db.commit()

def get_teams(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/team/")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 2
    assert data["items"][0].keys() >= team[0].keys()
    assert "id" in data["items"][0]

def add_checkpoint(client: TestClient) -> None:
    r = client.put(f"{settings.API_V1_STR}/team/0/checkpoint", json={"checkpoint_id": 1, "score": 100})
    data = r.json()
    assert r.status_code == 201
    assert data["id"] == 0
    assert data["scores"][0] == 100
    assert len(data["times"]) == 1