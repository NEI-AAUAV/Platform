import pytest
from typing import Any
from datetime import datetime
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import News, User
from app.tests.conftest import SessionTesting


USERS = [
    {
        "id": 2,
        "name": "Ze Pistolas",
        "surname": "Pistolas",
        "iupi": "x1x1",
        "curriculum": "ze_cv",
        "linkedin": "https://ze_linkedin",
        "github": "https://ze_git",
        "scopes": ["ADMIN"],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5),
    },
    {
        "id": 3,
        "name": "Francisco",
        "surname": "Miguel Abrantes",
        "iupi": "x2x2",
        "curriculum": "francisco_cv",
        "linkedin": "https://francisco_linkedin",
        "github": "https://francisco_git",
        "scopes": ["MANAGER_NEI", "MANAGER_TACAUA"],
        "created_at": datetime(2022, 8, 4),
        "updated_at": datetime(2022, 8, 5),
    },
]

NEWS = [
    {
        "header": "Test1",
        "public": True,
        "title": "NEWS TITLE PLACEHOLDER",
        "category": "EVENT",
        "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non diam placerat, ultrices libero sit amet, molestie dui. Praesent at purus sit amet velit aliquet commodo. Maecenas dapibus tellus purus.",
        "created_at": datetime.now().isoformat(),
        "updated_at": datetime.now().isoformat(),
        "author_id": 3,
    },
    {
        "header": "Test2",
        "public": False,
        "title": "NEWS TITLE PLACEHOLDER",
        "category": "Parceria",
        "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non diam placerat, ultrices libero sit amet, molestie dui. Praesent at purus sit amet velit aliquet commodo. Maecenas dapibus tellus purus.",
        "created_at": datetime(2016, 5, 5).isoformat(),
        "updated_at": datetime.now().isoformat(),
        "author_id": 2,
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for user in USERS:
        db.add(User(**user))
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


def test_get_specific_error(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/-1")
    assert r.status_code == 404


def test_get_categories(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/news/category")
    data = r.json()
    assert r.status_code == 200
    assert len(data["data"]) == 2
