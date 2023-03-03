import pytest
from datetime import datetime
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Competition, Group, Course, Team, Match
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/match"

modality_data = {
    "year": 0,
    "type": "Individual",
    "frame": "Misto",
    "sport": "Atletismo",
}

course_data = {
    "name": "Eng. Informática",
    "short": "NEI",
    "color": "rgb(0,0,0)",
}

teams_data = [
    {
        "name": "Equipa 1",
    },
    {
        "name": "Equipa 2",
    },
    {
        "name": "Equipa 3",
    },
    {
        "name": "Equipa 4",
    },
    {
        "name": "Equipa 5",
    },
    {
        "name": "Equipa 6",
    },
]

competition_data = {
    "name": "string",
    "started": False,
    "public": False,
    "metadata_": {
        "rank_by": "Vitórias",
        "system": "Eliminação Direta",
        "third_place_match": False,
    },
}

group_data = {
    "number": 0,
}


match_data = {
    "round": 1,
    "score1": 0,
    "score2": 0,
    "winner": None,
    "forfeiter": None,
    "date": datetime.fromtimestamp(0),
    "team1_prereq_match_id": None,
    "team2_prereq_match_id": None,
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    modality = Modality(**modality_data)
    db.add(modality)
    db.commit()
    db.refresh(modality)

    competition = Competition(modality_id=modality.id, **competition_data)
    db.add(competition)
    db.commit()
    db.refresh(competition)

    group = Group(competition_id=competition.id, number=1)
    db.add(group)
    db.commit()
    db.refresh(group)

    course = Course(**course_data)
    db.add(course)
    db.commit()
    db.refresh(course)

    teams = []
    for team_data in teams_data:
        team = Team(modality_id=modality.id, course_id=course.id, **team_data)
        db.add(team)
        db.commit()
        db.refresh(team)
        teams.append(team)

    db.add(
        Match(
            team1_id=teams[0].id, team2_id=teams[1].id, group_id=group.id, **match_data
        )
    )
    db.add(
        Match(
            team1_id=teams[2].id, team2_id=teams[3].id, group_id=group.id, **match_data
        )
    )
    db.add(
        Match(
            team1_id=teams[4].id, team2_id=teams[5].id, group_id=group.id, **match_data
        )
    )
    db.commit()


def test_update_match(db: SessionTesting, client: TestClient) -> None:
    matches = db.query(Match).all()

    this_match = matches[0]
    team1_match = matches[1]
    team2_match = matches[2]

    assert not this_match.live
    assert this_match.team1_id != team1_match.team1_id
    assert this_match.team2_id != team2_match.team2_id

    old_this_match = this_match.dict()
    old_team1_match = team1_match.dict()
    old_team2_match = team2_match.dict()

    r = client.put(
        f"{URL_PREFIX}/{this_match.id}",
        json={
            "live": True,
            "team1_id": team1_match.team1_id,
            "team2_id": team2_match.team2_id,
        },
        allow_redirects=True,
    )

    # Check response
    assert r.status_code == 200
    data = r.json()
    assert len(data) == 3
    assert data[0]["id"] == old_this_match["id"]
    assert data[0]["team1_id"] == old_team1_match["team1_id"]
    assert data[0]["team2_id"] == old_team2_match["team2_id"]
    assert data[0]["live"]

    # Check database
    assert this_match.team1_id == old_team1_match["team1_id"]
    assert this_match.team2_id == old_team2_match["team2_id"]

    assert team1_match.team1_id == old_this_match["team1_id"]
    assert team2_match.team2_id == old_this_match["team2_id"]

    assert this_match.live
    assert this_match.live
