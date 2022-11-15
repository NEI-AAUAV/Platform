import pytest
from typing import Any
from datetime import datetime
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import News, Users
from app.tests.conftest import SessionTesting
from app.schemas.news import StatusEnum, CategoryEnum


USERS = [
    {   
        "id": 2,
        "name": 'Ze Pistolas',
        "full_name": 'Ze Pistolas Pistolas',
        "uu_email": 'zpp@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": 'ze_cv',
        "linkedin": 'ze_linkedin',
        "git": 'ze_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "id": 3,
        "name": "Francisco Abrantes",
        "full_name": "Francisco Miguel Abrantes",
        "uu_email": "fma@ua.pt",
        "uu_yupi": 'x2x2',
        "curriculo": 'francisco_cv',
        "linkedin": 'francisco_linkedin',
        "git": 'francisco_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    }
]

NEWS = [
    {
        "header": "Test1",
        "status": 1,
        "title": "NEWS TITLE PLACEHOLDER",
        "category": "EVENT",
        "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non diam placerat, ultrices libero sit amet, molestie dui. Praesent at purus sit amet velit aliquet commodo. Maecenas dapibus tellus purus.",
        "published_by": 2,
        "created_at": datetime.now().isoformat(),
        "author_id": 3
    },
    {
        "header": "Test2",
        "status": 0,
        "title": "NEWS TITLE PLACEHOLDER",
        "category": "Parceria",
        "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non diam placerat, ultrices libero sit amet, molestie dui. Praesent at purus sit amet velit aliquet commodo. Maecenas dapibus tellus purus.",
        "published_by": 2,
        "created_at": datetime(2016,5,5).isoformat(),
        "author_id": 2
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for user in USERS:
        db.add(Users(**user))
    for news in NEWS:
        db.add(News(**news)) 
    db.commit()

def test_get_news(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 2
    assert data["items"][0].keys() >= NEWS[0].keys()
    assert "id" in data["items"][0]

def test_get_news_by_category(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/?category[]=Event")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 1
    assert data["items"][0].keys() >= NEWS[0].keys()

def test_get_news_by_categories(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/?category[]=Event&category[]=Parceria")
    data = r.json()
    assert r.status_code == 200
    assert len(data["items"]) == 2
    assert data["items"][1].keys() >= NEWS[1].keys()
    assert "id" in data["items"][0]

def test_nonexistant_category(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/?category[]=Event&category[]=TEST")
    data = r.json()
    assert r.status_code == 400

def test_get_specific_news(db: SessionTesting, client: TestClient) -> None:
    firstnew = db.query(News).first()
    r = client.get(f"{settings.API_V1_STR}/news/{firstnew.id}")
    data = r.json()
    assert data["id"] == firstnew.id

def test_get_specific_error(client:TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/-1")
    assert r.status_code == 404

def test_get_categories(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/categories")
    print(f"{settings.API_V1_STR}/news/categories")
    data = r.json()
    assert r.status_code == 200
    assert len(data['data']) == 2
