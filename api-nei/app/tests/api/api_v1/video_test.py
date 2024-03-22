import pytest
from typing import Any
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import VideoTag, Video
from app.tests.conftest import SessionTesting

videotags = [
    {"id": 0, "name": "Test1", "color": "#32a86b"},
    {"id": 1, "name": "Test2", "color": "#4832a8"},
]

videos = [
    {
        "tags": [0],
        "youtube_id": "xAcntjKChy8",
        "title": "Video 1",
        "subtitle": "Video 1 Sub",
        "image": "Image link here",
        "created_at": datetime.now().isoformat(),
        "playlist": 0,
    },
    {
        "tags": [1],
        "youtube_id": "PEad2KJ5RaE",
        "title": "Video 2",
        "subtitle": "Video 2 Sub",
        "image": "Image link here",
        "created_at": datetime(2016, 1, 1).isoformat(),
        "playlist": 0,
    },
    {
        "tags": [0, 1],
        "youtube_id": "KZokQov_aH0",
        "title": "Video 3",
        "subtitle": "Video 3 Sub",
        "image": "Image link here",
        "created_at": datetime(2017, 1, 1).isoformat(),
        "playlist": 0,
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for videotag in videotags:
        db.add(VideoTag(**videotag))
    db.commit()
    for video in videos:
        v = Video(**video)
        v.tags = [db.get(VideoTag, t) for t in video["tags"]]
        db.add(v)
    db.commit()


def test_get_video_Tags(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/video/category/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2
    assert data[0].items() >= videotags[0].items()
    assert "id" in data[0]


def test_get_videos_by_categories(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/video/?tag[]=0&tag[]=1&page=1")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 3
    assert data["items"][0].keys() >= videos[0].keys()
    assert "id" in data["items"][0]


def test_get_video(db: SessionTesting, client: TestClient) -> None:
    id = db.query(Video).first().id
    r = client.get(f"{settings.API_V1_STR}/video/{id}")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 8
    assert data.keys() >= videos[0].keys()
    assert "id" in data


def test_get_video_bad_request(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/video/?tag[]=-1")
    data = r.json()
    assert r.status_code == 400


def test_get_video_with_partial_info(db: SessionTesting, client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/video/?tag[]=0&tag[]=1")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 3
    assert data["items"][0].keys() >= videos[0].keys()
    assert "id" in data["items"][0]

    r = client.get(f"{settings.API_V1_STR}/video/?page=1")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 3
    assert data["items"][0].keys() >= videos[0].keys()
    assert "id" in data["items"][0]
