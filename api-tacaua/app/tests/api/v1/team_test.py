import json
import pytest
from io import BytesIO
from PIL import Image

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Course, Participant, Team
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/teams"

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

team_data = {
    "name": "Name",
}

participant_data = {
    "name": "Name",
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    modality = Modality(**modality_data)
    db.add(modality)
    db.commit()
    db.refresh(modality)

    course = Course(**course_data)
    db.add(course)
    db.commit()
    db.refresh(course)

    team = Team(course_id=course.id, modality_id=modality.id, **team_data)
    db.add(team)
    db.commit()
    db.refresh(team)

    db.add(Participant(team_id=team.id, **participant_data))
    db.commit()


def test_create_team(db: SessionTesting, client: TestClient) -> None:
    image = Image.new('RGB', size=(50, 50))
    image_file = BytesIO()
    image.save(image_file, 'JPEG')
    image_file.seek(0)

    files = {
        "image": ('img.JPG', image_file, 'image/jpeg'),
    }
    course = db.query(Course).first()
    modality = db.query(Modality).first()
    data = {
        "team": json.dumps({
            "course_id": course.id,
            "modality_id": modality.id,
            **team_data
        })
    }
    print(data)

    r = client.post(URL_PREFIX, data=data,
                    files=files, allow_redirects=True)
    print(r.json())

    assert r.status_code == 201
    data = r.json()
    assert 'id' in data
    assert 'image' in data
    assert 'participants' in data
    assert data.items() >= team_data.items()


def test_update_team(db: SessionTesting, client: TestClient) -> None:
    image = Image.new('RGB', size=(50, 50))
    image_file = BytesIO()
    image.save(image_file, 'JPEG')
    image_file.seek(0)

    course_data = {
        "name": "Eng. Mecânica",
        "short": "NEEMec",
        "color": "orange",
    }
    course = Course(**course_data)
    db.add(course)
    db.commit()
    db.refresh(course)

    files = {
        "image": ('img.JPG', image_file, 'image/jpeg'),
    }
    team = db.query(Team).first()
    team_partial_data = {
        "course_id": course.id,
    }
    r = client.put(f"{URL_PREFIX}/{team.id}",
                   data={"team": json.dumps(team_partial_data)},
                   files=files, allow_redirects=True)
    print(r.json())
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == team.id
    assert 'image' in data
    assert 'participants' in data
    assert data.items() >= team_partial_data.items()


def test_remove_team(db: SessionTesting, client: TestClient) -> None:
    team = db.query(Team).first()
    r = client.delete(f"{URL_PREFIX}/{team.id}")
    print(r.json())

    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == team.id
    assert 'participants' in data
