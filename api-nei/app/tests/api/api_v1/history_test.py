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
def lh3_image_urls(monkeypatch):
    """Pin the Drive image prefix: deployments override it (nginx proxy)."""
    monkeypatch.setattr(settings, "DRIVE_IMAGE_BASE_URL", "https://lh3.googleusercontent.com/d/")


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
        "weight": 0,
    }
    assert match["featured"] is True
    assert match["mandate"] == "2023/24"
    assert match["external_url"] == "https://example.com/noticia"
    assert match["external_label"] == "Ler notícia"
    assert "media" not in match  # photos are only listed by /gallery
    assert match["has_drive_gallery"] is False
    assert match["gallery_count"] == 0


def _gallery(client: TestClient, milestone_id: int) -> dict:
    r = client.get(f"{settings.API_V1_STR}/history/{milestone_id}/gallery")
    assert r.status_code == 200
    return r.json()


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

    media = _gallery(client, milestone.id)["media"]
    assert len(media) == 1
    assert media[0]["source"] == "drive"
    assert media[0]["caption"] == "Foto 1"
    assert media[0]["url"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w2000"
    assert media[0]["thumb"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w600"


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

    media = _gallery(client, milestone.id)["media"]
    assert media[0]["source"] == "upload"
    assert media[0]["url"].endswith(str(asset_id))
    assert media[0]["thumb"] == media[0]["url"] + "?width=600"


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

    assert _gallery(client, milestone.id)["media"] == []
    r = client.get(f"{settings.API_V1_STR}/history")
    match = next(el for el in r.json() if el["title"] == "Link Drive inválido")
    assert match["gallery_count"] == 0


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

    media = _gallery(client, milestone.id)["media"]
    assert [m["caption"] for m in media] == ["Primeira", "Segunda"]


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


# --- Drive folder galleries -------------------------------------------------

FOLDER_URL = "https://drive.google.com/drive/folders/1FolderIdAbC"


def _fake_folder(monkeypatch, result) -> list[str]:
    """Replace the Drive client's folder lookup; returns the ids asked for."""
    from app.api.api_v1 import history as history_api

    asked: list[str] = []

    async def list_folder(folder_id: str):
        asked.append(folder_id)
        if isinstance(result, Exception):
            raise result
        return result

    monkeypatch.setattr(history_api.drive_client, "list_folder", list_folder)
    return asked


def _folder(*file_ids: str, status: str = "ok"):
    from app.integrations.google_drive import DriveFolderResult, DriveImage

    return DriveFolderResult(
        status=status,
        images=tuple(DriveImage(file_id=f, width=800, height=600) for f in file_ids),
    )


def _milestone_with_folder(db: SessionTesting, title: str, **extra) -> History:
    milestone = History(moment=date(2024, 11, 1), title=title, drive_folder_url=FOLDER_URL, **extra)
    db.add(milestone)
    db.commit()
    return milestone


def _listed(client: TestClient, title: str) -> dict:
    r = client.get(f"{settings.API_V1_STR}/history")
    assert r.status_code == 200
    return next(el for el in r.json() if el["title"] == title)


def test_media_ids_are_namespaced_by_source(client: TestClient, db: SessionTesting) -> None:
    import uuid

    milestone = History(moment=date(2024, 12, 1), title="Ids estáveis")
    db.add(milestone)
    db.flush()
    upload = HistoryMedia(history_id=milestone.id, photo_asset=uuid.uuid4(), weight=0)
    db.add_all([
        upload,
        HistoryMedia(history_id=milestone.id, drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view", weight=1),
    ])
    db.commit()

    ids = [m["id"] for m in _gallery(client, milestone.id)["media"]]
    assert ids == [f"upload:{upload.id}", "drive:1AbCdEfGhIjK"]


def test_list_never_calls_drive(client: TestClient, db: SessionTesting, monkeypatch) -> None:
    asked = _fake_folder(monkeypatch, _folder("f1", "f2"))
    _milestone_with_folder(db, "Pasta com fotos")

    match = _listed(client, "Pasta com fotos")
    assert asked == []
    assert match["has_drive_gallery"] is True
    assert match["gallery_count"] is None  # unknown until the gallery opens
    assert match["cover"] is None


def test_list_answers_even_when_drive_would_hang(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    from app.api.api_v1 import history as history_api

    async def hang(_folder_id: str):
        raise AssertionError("the list must not touch Drive")

    monkeypatch.setattr(history_api.drive_client, "list_folder", hang)
    _milestone_with_folder(db, "Drive lento")

    assert _listed(client, "Drive lento")["has_drive_gallery"] is True


def test_list_prefers_the_milestone_image_as_cover(client: TestClient, db: SessionTesting) -> None:
    _milestone_with_folder(db, "Capa própria", image="/capa.png", image_alt="Fachada do DETI")

    match = _listed(client, "Capa própria")
    assert match["cover"].endswith("/capa.png")
    assert match["cover_alt"] == "Fachada do DETI"


def test_cover_from_a_gallery_photo_uses_its_caption_as_alt(
    client: TestClient, db: SessionTesting
) -> None:
    milestone = History(moment=date(2024, 12, 5), title="Capa da galeria")
    db.add(milestone)
    db.flush()
    db.add(HistoryMedia(history_id=milestone.id, drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view", caption="Equipa na receção", weight=0))
    db.commit()

    match = _listed(client, "Capa da galeria")
    assert match["cover"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w600"
    assert match["cover_alt"] == "Equipa na receção"


def test_cover_without_written_alt_is_null(client: TestClient, db: SessionTesting) -> None:
    db.add(History(moment=date(2024, 12, 6), title="Sem alt", image="/x.png"))
    db.commit()

    assert _listed(client, "Sem alt")["cover_alt"] is None


def test_list_without_folder_counts_own_media(client: TestClient, db: SessionTesting) -> None:
    milestone = History(moment=date(2024, 12, 2), title="Só fotos próprias")
    db.add(milestone)
    db.flush()
    db.add(HistoryMedia(history_id=milestone.id, drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view", weight=0))
    db.commit()

    match = _listed(client, "Só fotos próprias")
    assert match["gallery_count"] == 1
    assert match["cover"] == "https://lh3.googleusercontent.com/d/1AbCdEfGhIjK=w600"


def test_gallery_appends_folder_photos_without_duplicates(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    _fake_folder(monkeypatch, _folder("1AbCdEfGhIjK", "f2"))
    milestone = _milestone_with_folder(db, "Galeria mista")
    db.add(HistoryMedia(history_id=milestone.id, drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view", caption="Destacada", weight=0))
    db.commit()

    data = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery").json()
    assert data["drive_status"] == "ok"
    assert data["truncated"] is False
    assert [m["id"] for m in data["media"]] == ["drive:1AbCdEfGhIjK", "drive:f2"]
    assert data["media"][0]["caption"] == "Destacada"
    assert (data["media"][1]["width"], data["media"][1]["height"]) == (800, 600)


def test_gallery_reports_an_unavailable_folder(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    _fake_folder(monkeypatch, _folder(status="unavailable"))
    milestone = _milestone_with_folder(db, "Galeria privada")

    data = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery").json()
    assert data["drive_status"] == "unavailable"
    assert data["media"] == []


def test_gallery_without_folder_has_no_drive_status(client: TestClient, db: SessionTesting) -> None:
    milestone = History(moment=date(2024, 12, 3), title="Sem pasta")
    db.add(milestone)
    db.commit()

    data = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery").json()
    assert data["drive_status"] is None


@pytest.mark.parametrize(
    "url,expected",
    [
        ("https://example.com/a", "https://example.com/a"),
        ("http://example.com/a", "http://example.com/a"),
        ("javascript:alert(1)", None),
        ("JaVaScRiPt:alert(1)", None),
        ("data:text/html,<script>1</script>", None),
        ("//evil.example.com", None),
    ],
)
def test_external_url_only_allows_http_links(
    client: TestClient, db: SessionTesting, url: str, expected: str | None
) -> None:
    db.add(History(moment=date(2024, 12, 4), title="Ligação", external_url=url))
    db.commit()

    assert _listed(client, "Ligação")["external_url"] == expected


def test_gallery_without_folder_never_calls_drive(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    asked = _fake_folder(monkeypatch, _folder("f1"))
    milestone = History(moment=date(2024, 12, 7), title="Só uploads")
    db.add(milestone)
    db.commit()

    _gallery(client, milestone.id)
    assert asked == []


def test_gallery_with_an_unparseable_folder_link_is_unavailable_without_calling_drive(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    asked = _fake_folder(monkeypatch, _folder("f1"))
    milestone = History(
        moment=date(2024, 12, 8),
        title="Pasta inválida",
        drive_folder_url="https://example.com/drive/folders/1FolderIdAbC",
    )
    db.add(milestone)
    db.commit()

    data = _gallery(client, milestone.id)
    assert asked == []
    assert data["drive_status"] == "unavailable"


@pytest.mark.parametrize("status", ["error", "disabled"])
def test_gallery_soft_fails_to_own_media_when_drive_is_down_or_disabled(
    client: TestClient, db: SessionTesting, monkeypatch, status: str
) -> None:
    _fake_folder(monkeypatch, _folder(status=status))
    milestone = _milestone_with_folder(db, f"Drive {status}")
    db.add(HistoryMedia(history_id=milestone.id, drive_url="https://drive.google.com/file/d/1AbCdEfGhIjK/view", weight=0))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery")
    assert r.status_code == 200
    assert r.json()["drive_status"] == status
    assert [m["id"] for m in r.json()["media"]] == ["drive:1AbCdEfGhIjK"]


def test_degraded_gallery_is_not_cached_by_the_browser(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    _fake_folder(monkeypatch, _folder(status="error"))
    milestone = _milestone_with_folder(db, "Drive falhou")

    r = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery")
    assert r.headers["Cache-Control"] == "no-store"


def test_healthy_gallery_keeps_the_cms_cache_header(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    _fake_folder(monkeypatch, _folder("f1"))
    milestone = _milestone_with_folder(db, "Drive bem")

    r = client.get(f"{settings.API_V1_STR}/history/{milestone.id}/gallery")
    assert r.headers["Cache-Control"].startswith("private, max-age=60")


def test_gallery_reports_a_truncated_folder(
    client: TestClient, db: SessionTesting, monkeypatch
) -> None:
    from dataclasses import replace

    _fake_folder(monkeypatch, replace(_folder("f1", "f2"), truncated=True))
    milestone = _milestone_with_folder(db, "Pasta enorme")

    data = _gallery(client, milestone.id)
    assert data["truncated"] is True
    assert len(data["media"]) == 2


# --- Domain constraints (Directus writes straight to the DB) ---------------

@pytest.mark.parametrize("mandate", ["2025/26", "1993/94", None])
def test_valid_mandates_are_accepted(db: SessionTesting, mandate) -> None:
    db.add(History(moment=date(2024, 1, 1), title="Mandato", mandate=mandate))
    db.flush()


@pytest.mark.parametrize("mandate", ["2025", "2025/6", "25/26", "2025-26", "2025/ab", "abc", ""])
def test_malformed_mandates_are_rejected(db: SessionTesting, mandate: str) -> None:
    from sqlalchemy.exc import IntegrityError

    db.add(History(moment=date(2024, 1, 1), title="Mandato", mandate=mandate))
    with pytest.raises(IntegrityError, match="ck_history_mandate_format"):
        db.flush()
    db.rollback()


@pytest.mark.parametrize("slug", ["Evento", "com espaço", "acentuação", "", "a_b"])
def test_malformed_category_slugs_are_rejected(db: SessionTesting, slug: str) -> None:
    from sqlalchemy.exc import IntegrityError

    db.add(HistoryCategory(slug=slug, label="X"))
    with pytest.raises(IntegrityError, match="ck_history_category_slug_format"):
        db.flush()
    db.rollback()


def test_category_slug_cannot_change_but_label_can(db: SessionTesting) -> None:
    """Shared `?categoria=<slug>` links must survive CMS edits."""
    from sqlalchemy.exc import IntegrityError

    category = HistoryCategory(slug="estavel", label="Estável")
    db.add(category)
    db.flush()

    category.label = "Novo nome"
    db.flush()

    category.slug = "outro-slug"
    with pytest.raises(IntegrityError, match="slug cannot change"):
        db.flush()
    db.rollback()
