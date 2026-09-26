import re
import pytest
from typing import Any
from datetime import datetime, date

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import History, HistoryCategory, HistoryMedia
from app.tests.conftest import SessionTesting

HISTORY = [
    {
        "moment": date(2022,1,2).isoformat(),
        "title": "TituloHistory",
        "body": "Texto muito interessante",
        "image": "/nei.png"
    },
    {
        "moment": date(1993,1,2).isoformat(),
        "title": "TituloHistory2",
        "body": "Texto muito pouco interessante"
    },
]

@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for hist in HISTORY:
        db.add(History(**hist))
    db.commit()

def test_elements(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        data2 = dict(HISTORY[i])
        image = data2.pop('image', None)
        assert data[i].items() >= data2.items()
        if image:
            assert data[i]['image'].endswith(image)

def test_date(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert re.match("([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])",el["moment"])

def test_text(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for el in data:
        assert len(el["title"]) > 0 and len(el["body"]) > 0

def test_img(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history")
    data = r.json()
    assert r.status_code == 200
    for i in range(len(data)):
        if HISTORY[i].get("image") != None:
            assert data[i]["image"]#Checkar se caso haja imagem, existe string


def test_unpublished_milestone_is_hidden(client: TestClient, db: SessionTesting) -> None:
    db.add(History(moment=date(2020, 5, 1), title="Rascunho", published=False))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    titles = [el["title"] for el in r.json()]
    assert "Rascunho" not in titles


def test_editorial_fields_are_returned(client: TestClient, db: SessionTesting) -> None:
    category = HistoryCategory(slug="categoria-teste", label="Categoria de teste", color="hsl(0 0% 50%)")
    db.add(category)
    db.flush()
    db.add(
        History(
            moment=date(2024, 3, 1),
            title="Marco destacado",
            category_id=category.id,
            featured=True,
            mandate="2023/24",
            external_url="https://example.com/noticia",
            external_label="Ler notícia",
        )
    )
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Marco destacado")
    assert match["category"] == {
        "slug": "categoria-teste",
        "label": "Categoria de teste",
        "color": "hsl(0 0% 50%)",
    }
    assert match["featured"] is True
    assert match["mandate"] == "2023/24"
    assert match["external_url"] == "https://example.com/noticia"
    assert match["external_label"] == "Ler notícia"
    assert match["media"] == []
    assert match["has_drive_gallery"] is False


def test_media_gallery_items_are_shaped(client: TestClient, db: SessionTesting) -> None:
    milestone = History(moment=date(2024, 4, 1), title="Com galeria")
    db.add(milestone)
    db.flush()
    db.add(
        HistoryMedia(
            history_id=milestone.id,
            drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view",
            caption="Foto 1",
            weight=0,
        )
    )
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Com galeria")
    assert len(match["media"]) == 1
    assert match["media"][0]["source"] == "drive"
    assert match["media"][0]["caption"] == "Foto 1"
    assert match["media"][0]["url"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w2000"
    assert match["media"][0]["thumb"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w600"


def test_gallery_endpoint_returns_media(client: TestClient, db: SessionTesting) -> None:
    milestone = History(moment=date(2024, 5, 1), title="Galeria completa")
    db.add(milestone)
    db.flush()
    db.add(
        HistoryMedia(
            history_id=milestone.id,
            drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view",
            weight=0,
        )
    )
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery")
    assert r.status_code == 200
    data = r.json()
    assert data["id"] == milestone.id
    assert data["title"] == "Galeria completa"
    assert len(data["media"]) == 1


def test_gallery_endpoint_404_for_missing_milestone(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/history/999999/gallery")
    assert r.status_code == 404


def test_gallery_endpoint_404_for_unpublished_milestone(
    client: TestClient, db: SessionTesting
) -> None:
    milestone = History(moment=date(2024, 6, 1), title="Escondido", published=False)
    db.add(milestone)
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery")
    assert r.status_code == 404


def test_milestone_without_a_category_returns_null(
    client: TestClient, db: SessionTesting
) -> None:
    db.add(History(moment=date(2024, 7, 1), title="Sem categoria"))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    assert r.status_code == 200
    match = next(el for el in r.json() if el["title"] == "Sem categoria")
    assert match["category"] is None


def test_deleting_a_category_uncategorizes_its_milestones_instead_of_cascading(
    client: TestClient, db: SessionTesting
) -> None:
    """`category_id` is ON DELETE SET NULL: removing a category from the
    CMS should never take milestones down with it."""
    category = HistoryCategory(slug="temporaria", label="Temporária")
    db.add(category)
    db.flush()
    db.add(History(moment=date(2024, 8, 1), title="Marco órfão", category_id=category.id))
    db.commit()

    db.delete(category)
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    assert r.status_code == 200
    match = next(el for el in r.json() if el["title"] == "Marco órfão")
    assert match["category"] is None


def test_uploaded_media_thumb_requests_a_resized_variant(
    client: TestClient, db: SessionTesting
) -> None:
    import uuid

    milestone = History(moment=date(2024, 8, 1), title="Com upload")
    db.add(milestone)
    db.flush()
    asset_id = uuid.uuid4()
    db.add(HistoryMedia(history_id=milestone.id, photo_asset=asset_id, weight=0))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Com upload")
    assert match["media"][0]["source"] == "upload"
    assert match["media"][0]["url"].endswith(str(asset_id))
    assert match["media"][0]["thumb"] == match["media"][0]["url"] + "?width=600"


def test_media_with_an_unparseable_drive_link_is_silently_dropped(
    client: TestClient, db: SessionTesting
) -> None:
    milestone = History(moment=date(2024, 9, 1), title="Link Drive inválido")
    db.add(milestone)
    db.flush()
    db.add(
        HistoryMedia(
            history_id=milestone.id,
            drive_url="https://not-drive.example.com/whatever",
            weight=0,
        )
    )
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Link Drive inválido")
    assert match["media"] == []


def test_media_ordering_follows_weight(client: TestClient, db: SessionTesting) -> None:
    milestone = History(moment=date(2024, 10, 1), title="Ordem da galeria")
    db.add(milestone)
    db.flush()
    db.add_all(
        [
            HistoryMedia(
                history_id=milestone.id,
                drive_url="https://drive.google.com/file/d/2AbCdEfGhIjK/view",
                caption="Segunda",
                weight=1,
            ),
            HistoryMedia(
                history_id=milestone.id,
                drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view",
                caption="Primeira",
                weight=0,
            ),
        ]
    )
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Ordem da galeria")
    assert [m["caption"] for m in match["media"]] == ["Primeira", "Segunda"]


def test_list_is_sorted_by_moment_then_id_descending(
    client: TestClient, db: SessionTesting
) -> None:
    same_day = date(2024, 1, 1)
    db.add(History(moment=same_day, title="Marco A"))
    db.add(History(moment=same_day, title="Marco B"))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history")
    titles = [el["title"] for el in r.json() if el["moment"] == same_day.isoformat()]
    assert titles == ["Marco B", "Marco A"]
