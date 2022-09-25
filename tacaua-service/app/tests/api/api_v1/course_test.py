import json
import pytest
from typing import Any
from io import BytesIO
from PIL import Image

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Course
from app.tests.conftest import SessionTesting


URL_PREFIX = f"{settings.API_V1_STR}/course"

course_data = {
    "name": "Eng. Informática",
    "initials": "NEI",
    "color": "rgb(0,0,0)",
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    course = Course(**course_data)
    db.add(course)
    db.commit()


def test_get_multi_course(client: TestClient) -> None:
    r = client.get(URL_PREFIX)
    assert r.status_code == 200
    data = r.json()
    assert 'courses' in data
    assert len(data['courses'] == 1)
    assert 'id' in data['courses'][0]


def test_get_course(db: SessionTesting, client: TestClient) -> None:
    course = db.query(Course).first()
    r = client.get(f"{URL_PREFIX}/{course.id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == course.id
    assert data.items() >= course.dict().items()


def test_get_inexistent_course(client: TestClient) -> None:
    id = 99
    r = client.get(f"{URL_PREFIX}/{id}")
    assert r.status_code == 404
    data = r.json()
    assert data["detail"] == "Course Not Found"


def test_create_course(client: TestClient) -> None:
    svg_file = b"""<?xml version="1.0"?>
    <svg xmlns="http://www.w3.org/2000/svg" width="500" height="500">
    <rect width="500" height="500" style="fill:rgb(0,0,0)" /></svg>
    """

    files = {
        "image": ('img.SVG', svg_file, 'image/svg+xml'),
    }
    r = client.post(URL_PREFIX, data={"course": json.dumps(course_data)},
                    files=files, allow_redirects=True)
    assert r.status_code == 201
    data = r.json()
    assert 'id' in data
    assert 'image' in data
    assert data.items() >= course_data.items()


def test_update_course(db: SessionTesting, client: TestClient) -> None:
    svg_file = b"""<?xml version="1.0"?>
    <svg xmlns="http://www.w3.org/2000/svg" width="500" height="500">
    <rect width="500" height="500" style="fill:rgb(0,0,0)" /></svg>
    """

    files = {
        "image": ('img.SVG', svg_file, 'image/svg+xml'),
    }
    course = db.query(Course).first()
    course_partial_data = {
        "year": 1,
        "frame": "Feminino",
        "sport": "Andebol",
    }
    r = client.put(f"{URL_PREFIX}/{course.id}",
                   data={"course": json.dumps(course_partial_data)},
                   files=files, allow_redirects=True)
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == course.id
    assert 'image' in data
    assert 'competitions' in data
    assert not data.items() >= course_data.items()
    assert data.items() >= course_partial_data.items()


def test_remove_course(db: SessionTesting, client: TestClient) -> None:
    course = db.query(Course).first()
    r = client.delete(f"{URL_PREFIX}/{course.id}")
    assert r.status_code == 200
    data = r.json()
    assert 'id' in data
    assert data['id'] == course.id
    assert 'competitions' in data
    assert len(data['competitions']) == 1
    competitions = db.query(Competition).filter(
        Competition.course_id == course.id).all()
    assert len(competitions) == 0
