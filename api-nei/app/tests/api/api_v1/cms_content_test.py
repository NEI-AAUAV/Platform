"""Endpoint-level coverage for rows shaped the way the CMS writes them.

Directus writes straight to Postgres, so a saved-but-incomplete row reaches
the response models without ever passing through FastAPI's validation. These
are list endpoints, so one such row used to 500 the whole page.
"""

from datetime import datetime

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings, Settings
from app.models import History, Merch, News, Partner
from app.models.team import TeamMandate, TeamMember, TeamSection
from app.models.user import User
from app.schemas.news import CategoryEnum
from app.schemas.user import ScopeEnum
from app.tests.conftest import SessionTesting

from ._utils import auth_data

PREFIX = settings.API_V1_STR


@pytest.fixture
def author(db: SessionTesting) -> User:
    user = User(
        name="Ana",
        surname="Silva",
        scopes=[],
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(user)
    db.flush()
    return user


def test_news_list_survives_blank_header_and_content(
    client: TestClient, db: SessionTesting, author: User
):
    db.add(
        News(
            author_id=author.id,
            category=CategoryEnum.NEWS,
            title="Sem imagem",
            header=None,
            content=None,
            public=True,
            created_at=datetime(2026, 1, 1),
            updated_at=datetime(2026, 1, 1),
        )
    )
    db.flush()

    response = client.get(f"{PREFIX}/news/")

    assert response.status_code == 200
    item = response.json()["items"][0]
    assert item["header"] is None
    assert item["content"] is None


def test_merch_list_survives_missing_image(client: TestClient, db: SessionTesting):
    db.add(Merch(name="Caneca", image=None, price=5.0, number_of_items=1))
    db.flush()

    response = client.get(f"{PREFIX}/merch/")

    assert response.status_code == 200
    assert response.json()[0]["image"] is None


def test_partner_list_survives_blank_description_and_header(
    client: TestClient, db: SessionTesting
):
    db.add(Partner(company="ACME", description=None, header=None))
    db.flush()

    response = client.get(f"{PREFIX}/partner/")

    assert response.status_code == 200
    item = response.json()[0]
    assert item["description"] is None
    assert item["header"] is None


def test_history_list_survives_blank_body(client: TestClient, db: SessionTesting):
    db.add(History(moment=datetime(2020, 5, 5).date(), title="Fundação", body=None))
    db.flush()

    response = client.get(f"{PREFIX}/history/")

    assert response.status_code == 200
    assert response.json()[0]["body"] is None


def test_news_list_excludes_drafts(
    client: TestClient, db: SessionTesting, author: User
):
    common = dict(
        author_id=author.id,
        category=CategoryEnum.NEWS,
        content="x",
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(News(title="Publicada", public=True, **common))
    db.add(News(title="RASCUNHO", public=False, **common))
    db.flush()

    response = client.get(f"{PREFIX}/news/")

    assert response.status_code == 200
    titles = [item["title"] for item in response.json()["items"]]
    assert titles == ["Publicada"]


def test_news_detail_404s_for_a_draft(
    client: TestClient, db: SessionTesting, author: User
):
    draft = News(
        author_id=author.id,
        category=CategoryEnum.NEWS,
        title="RASCUNHO",
        content="x",
        public=False,
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(draft)
    db.flush()

    assert client.get(f"{PREFIX}/news/{draft.id}").status_code == 404


def test_news_categories_exclude_draft_only_categories(
    client: TestClient, db: SessionTesting, author: User
):
    db.add(
        News(
            author_id=author.id,
            category=CategoryEnum.PARCERIA,
            title="RASCUNHO",
            content="x",
            public=False,
            created_at=datetime(2026, 1, 1),
            updated_at=datetime(2026, 1, 1),
        )
    )
    db.flush()

    response = client.get(f"{PREFIX}/news/category")

    assert response.status_code == 200
    assert CategoryEnum.PARCERIA.value not in response.json()["data"]


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.MANAGER_NEI])], indirect=True
)
def test_delete_team_member(client: TestClient, db: SessionTesting):
    mandate = TeamMandate(mandate="2026/27")
    db.add(mandate)
    db.flush()
    section = TeamSection(mandate_id=mandate.id, name="Direção", weight=0)
    db.add(section)
    db.flush()
    member = TeamMember(name="Ana Silva", role="Vogal", section_id=section.id, weight=0)
    db.add(member)
    db.flush()

    response = client.delete(f"{PREFIX}/team/member/{member.id}")

    assert response.status_code != 500
    assert response.status_code in (200, 201, 204)
    assert db.query(TeamMember).filter(TeamMember.id == member.id).first() is None


@pytest.mark.parametrize(
    "configured, expected",
    [
        ("https://nei.web.ua.pt/cms", "https://nei.web.ua.pt/cms/"),
        ("https://nei.web.ua.pt/cms/", "https://nei.web.ua.pt/cms/"),
    ],
)
def test_directus_public_url_always_ends_in_a_slash(
    monkeypatch: pytest.MonkeyPatch, configured: str, expected: str
):
    monkeypatch.setenv("DIRECTUS_PUBLIC_URL", configured)

    assert Settings().DIRECTUS_PUBLIC_URL == expected
