import pytest

from fastapi.testclient import TestClient

from app.models import Team
from app.core.config import settings
from app.schemas.team import TeamScoresUpdate
from app.tests.conftest import Session

team = [
    {
        "name": "Test1",
    },
    {
        "name": "Test2",
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: Session):
    """Setup the database before each test in this module."""

    for teams in team:
        db.add(Team(**teams))
    db.commit()


@pytest.mark.parametrize(
    "client",
    [{}],
    indirect=["client"],
)
def test_get_teams(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/team/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert data[0].keys() >= team[0].keys()
    assert "id" in data[0]


@pytest.mark.parametrize(
    "client",
    [{"staff_checkpoint_id": 1}],
    indirect=["client"],
)
def test_add_checkpoint(client: TestClient, db: Session) -> None:
    team = db.query(Team).first()
    assert team is not None
    id = team.id

    r = client.put(
        f"{settings.API_V1_STR}/team/{id}/checkpoint",
        json=TeamScoresUpdate(question_score=True).model_dump(),
    )
    data = r.json()
    assert r.status_code == 201
    assert data["id"] == id
    assert len(data["question_scores"]) == 1
    assert data["question_scores"][0]
    assert len(data["times"]) == 1


@pytest.mark.parametrize(
    "client",
    [{"is_admin": True}],
    indirect=["client"],
)
def test_create_team(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/team/", json={"name": "Test3"})
    data = r.json()
    assert r.status_code == 201
    assert data["name"] == "Test3"


# =================
# == UPDATE TEAM ==
# =================


def test_update_team_unauthenticated(client: TestClient, db: Session) -> None:
    team = db.query(Team).first()
    assert team is not None
    id = team.id

    r = client.put(
        f"{settings.API_V1_STR}/team/{id}",
        json={
            "name": "Test1",
            "pukes": [0],
            "skips": [0],
            "time_scores": [100],
            "question_scores": [True],
            "times": ["2021-05-01T12:00:00"],
        },
    )
    assert r.status_code == 401


@pytest.mark.parametrize(
    "client",
    [{}],
    indirect=["client"],
)
def test_update_team_normal_user(client: TestClient, db: Session) -> None:
    team = db.query(Team).first()
    assert team is not None
    id = team.id

    r = client.put(
        f"{settings.API_V1_STR}/team/{id}",
        json={
            "name": "Test1",
            "pukes": [0],
            "skips": [0],
            "time_scores": [100],
            "question_scores": [True],
            "times": ["2021-05-01T12:00:00"],
        },
    )
    assert r.status_code == 403


@pytest.mark.parametrize(
    "client",
    [{"staff_checkpoint_id": 1}],
    indirect=["client"],
)
def test_update_team_staff(client: TestClient, db: Session) -> None:
    team = db.query(Team).first()
    assert team is not None
    id = team.id

    r = client.put(
        f"{settings.API_V1_STR}/team/{id}",
        json={
            "name": "Test1",
            "pukes": [0],
            "skips": [0],
            "time_scores": [100],
            "question_scores": [True],
            "times": ["2021-05-01T12:00:00"],
        },
    )
    assert r.status_code == 403


@pytest.mark.parametrize(
    "client",
    [{"is_admin": True}],
    indirect=["client"],
)
def test_update_team_admin(client: TestClient, db: Session) -> None:
    team = db.query(Team).first()
    assert team is not None
    id = team.id

    r = client.put(
        f"{settings.API_V1_STR}/team/{id}",
        json={
            "name": "Test1",
            "pukes": [0],
            "skips": [0],
            "time_scores": [100],
            "question_scores": [True],
            "times": ["2021-05-01T12:00:00"],
        },
    )
    data = r.json()
    assert r.status_code == 200
    assert data["name"] == "Test1"
    assert data["pukes"] == [0]
    assert data["skips"] == [0]
    assert data["time_scores"] == [100]
    assert data["question_scores"] == [True]
    assert data["times"] == ["2021-05-01T12:00:00"]
