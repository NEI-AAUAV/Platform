import pytest

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models.team import Team
from app.tests.conftest import SessionTesting

team = [
    {
        "name": "Test1",
        "scores": [],
        "times": []
    },
    {
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

def test_get_teams(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/team/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert data[0].keys() >= team[0].keys()
    assert "id" in data[0]


def test_add_checkpoint(client: TestClient, db: SessionTesting) -> None:
    id = db.query(Team).first().id
    r = client.put(f"{settings.API_V1_STR}/team/{id}/checkpoint", json={"checkpoint_id": 1, "score": 100})
    data = r.json()
    assert r.status_code == 201
    print(data)
    assert data["id"] == id
    assert data["scores"][0] == 100
    assert len(data["times"]) == 1

def test_create_team(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/team/", json={"name": "Test3"})
    data = r.json()
    print(data)
    assert r.status_code == 201
    assert data["name"] == "Test3"

def test_update_team(client: TestClient, db: SessionTesting) -> None:
    id = db.query(Team).first().id
    r = client.put(f"{settings.API_V1_STR}/team/{id}", json={"name": "Test1", "scores": [100], "times": ["2021-05-01T12:00:00"], "scores": [50,5,2]})
    data = r.json()
    assert r.status_code == 200
    assert data["name"] == "Test1"
    assert data["scores"] == [50,5,2]
    assert data["times"] == ["2021-05-01T12:00:00"]
