import pytest
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Partner
from app.tests.conftest import SessionTesting


PARTNERS = [
    {
        "id": 1,
        "header": "Cat123456",
        "company": "Cat123456",
        "description": "Cat123456",
        "content": "Cat123456",
        "link": "https://nei.web.ua.pt/nei.png",
        "banner_url": "https://nei.web.ua.pt/nei.png",
        "banner_image": "/nei.png",
        "banner_until": datetime(2022, 7, 19).isoformat()
    },
    {
        "id": 23,
        "header": "Cat123456",
        "company": "Cat123456",
        "description": "Cat123456",
        "content": "Cat123456",
        "link": "https://nei.web.ua.pt/nei.png"
    }

]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for prtns in PARTNERS:
        db.add(Partner(**prtns))
    db.commit()


def test_elements(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/partner")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        data2 = dict(PARTNERS[i])
        header = data2.pop('header', None)
        banner_image = data2.pop('banner_image', None)
        assert data[i].items() >= data2.items()
        if header:
            assert data[i]['header'].endswith(header)
        if banner_image:
            assert data[i]['banner_image'].endswith(banner_image)


def test_text(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/partner")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert len(el["header"]) > 0
        assert len(el["company"]) > 0
        assert len(el["description"]) > 0
        assert len(el["content"]) > 0


def test_img(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/partner")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        if PARTNERS[i].get("banner_image") != None:
            # Checkar se caso haja imagem, existe string
            assert data[i]["banner_image"]

        if PARTNERS[i].get("banner_image") != None:
            # Checkar se caso haja imagem, existe string
            assert data[i]["banner_url"]
