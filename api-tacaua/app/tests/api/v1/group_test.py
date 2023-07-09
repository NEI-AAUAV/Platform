import json

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Competition, Group, Course, Team
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/group"

modality_data = {
    "year": 0,
    "type": "Individual",
    "frame": "Misto",
    "sport": "Atletismo",
}

competition_data = {
    "name": "string",
    "started": False,
    "public": False,
    "_metadata": {
        "rank_by": "Vitórias",
        "system": "Eliminação Direta",
        "third_place_match": False,
    }
}

course_data = {
    "name": "Eng. Informática",
    "short": "NEI",
    "color": "rgb(0,0,0)",
}

team_data = {
    "name": "Name",
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    modality = Modality(**modality_data)
    db.add(modality)
    db.commit()
    db.refresh(modality)

    modality2 = Modality(**modality_data)
    db.add(modality2)
    db.commit()
    db.refresh(modality2)

    competition = Competition(modality_id=modality.id, **competition_data)
    db.add(competition)
    db.commit()
    db.refresh(competition)

    db.add(Group(competition_id=competition.id, number=1))
    db.commit()

    course = Course(**course_data)
    db.add(course)
    db.commit()
    db.refresh(course)

    db.add(Team(modality_id=modality.id, course_id=course.id, **team_data))
    db.commit()

    db.add(Team(modality_id=modality2.id, course_id=course.id, **team_data))
    db.commit()


def test_create_group(db: SessionTesting, client: TestClient) -> None:
    id = db.query(Competition).first().id
    r = client.post(URL_PREFIX, json={"competition_id": id},
                    allow_redirects=True)
    assert r.status_code == 201
    data = r.json()
    assert 'id' in data
    assert 'name' in data


def test_update_group_with_team_in_modality(db: SessionTesting, client: TestClient) -> None:
    group = db.query(Group).first()
    competition = db.get(Competition, group.competition_id)
    teams = db.query(Team).filter(Team.modality_id == competition.modality_id).all()

    r = client.put(f"{URL_PREFIX}/{group.id}", json={'teams_id': [teams[0].id]})
    print(r.json())
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert 'name' in data


def test_update_group_with_team_not_in_modality(db: SessionTesting, client: TestClient) -> None:
    group = db.query(Group).first()
    competition = db.get(Competition, group.competition_id)
    teams = db.query(Team).filter(Team.modality_id != competition.modality_id).all()

    r = client.put(f"{URL_PREFIX}/{group.id}", json={'teams_id': [teams[0].id]})
    print(r.json())
    assert r.status_code == 404


def test_remove_group(db: SessionTesting, client: TestClient) -> None:
    group = db.query(Group).first()
    r = client.delete(f"{URL_PREFIX}/{group.id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == group.id
    competition = db.query(Competition).filter(
        Competition.id == data['competition_id']).first()
    assert len(competition.groups) == 0
