import pytest
from typing import Any
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import VideoTag, Video
from app.tests.conftest import SessionTesting

videotag = [
    {
        "id": 0,
        "name": "Test1",
        "color": "#32a86b"
    },
    {
        "id": 1,
        "name": "Test2",
        "color": "#4832a8"
    }
]

videos = [
    {
        "tags": [0],
        "ytld": "xAcntjKChy8",
        "title": "Video 1",
        "subtitle": "Video 1 Sub",
        "image": "Image link here",
        "created": datetime.now().isoformat(),
        "playlist": 0
    },
    {
        "tags": [1],
        "ytld": "PEad2KJ5RaE",
        "title": "Video 2",
        "subtitle": "Video 2 Sub",
        "image": "Image link here",
        "created": datetime(2016, 1, 1).isoformat(),
        "playlist": 0
    },
    {
        "tags": [0, 1],
        "ytld": "KZokQov_aH0",
        "title": "Video 3",
        "subtitle": "Video 3 Sub",
        "image": "Image link here",
        "created": datetime(2017, 1, 1).isoformat(),
        "playlist": 0
    }
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for videotags in videotag:
        db.add(VideoTag(**videotags))
    db.commit()
    for video in videos:
        Vcopy = video.copy()
        tags = Vcopy.pop("tags")
        v = Video(**Vcopy)
        db.add(v)
        db.commit()
        db.refresh(v)
        v.tags = tags
        db.add(v)
    db.commit()

def test_get_VideoTags(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/videos/categories/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert data[0].items() >= videotag[0].items()
    assert "id" in data[0]

def test_get_VideosbyCategories(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/videos/?category[]=0&category[]=1&page=1")
    data = r.json()
    print(data)
    assert r.status_code == 200
    assert len(data) == 3
    assert data[0].items() >= video[0].items()
    assert "id" in data[0]
"""
def test_get_Video(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/videos/?category[]=0&category[]=1&page=1&video=0")
    data = r.json()
    print(data)
    assert r.status_code == 200
    assert len(data) == 1
    assert data[0].items() >= video[0].items()
    assert "id" in data[0]

def test_get_VideoBadRequest(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/videos/")
    data = r.json()
    print(data)
    assert r.status_code == 400

def test_get_VideoWithPartialInfo(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/videos/?category[]=0&category[]=1")
    data = r.json()
    print(data)
    assert r.status_code == 200
    assert len(data) == 3
    assert data[0].items() >= video[0].items()
    assert "id" in data[0]
    
    r = client.get(f"{settings.API_V1_STR}/videos/?page=1")
    data = r.json()
    print(data)
    assert r.status_code == 200
    assert len(data) == 3
    assert data[0].items() >= video[0].items()
    assert "id" in data[0]


"""