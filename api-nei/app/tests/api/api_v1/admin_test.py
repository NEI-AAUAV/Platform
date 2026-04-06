from datetime import datetime
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from app.api.api_v1.admin import _validate_uuid
from app.core.config import settings
from app.models.user import User
from app.models.user.user_email import UserEmail
from app.schemas.user import ScopeEnum
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting


# ---------------------------------------------------------------------------
# _validate_uuid (pure function)
# ---------------------------------------------------------------------------


def test_validate_uuid_accepts_valid():
    valid = "550e8400-e29b-41d4-a716-446655440000"
    assert _validate_uuid(valid, "group_pk") == valid


def test_validate_uuid_rejects_path_traversal():
    with pytest.raises(HTTPException) as exc:
        _validate_uuid("../../etc/passwd", "group_pk")
    assert exc.value.status_code == 422


def test_validate_uuid_rejects_non_uuid_string():
    with pytest.raises(HTTPException) as exc:
        _validate_uuid("not-a-uuid-at-all", "group_pk")
    assert exc.value.status_code == 422


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

_GROUP_UUID = "550e8400-e29b-41d4-a716-446655440000"
_AUTHENTIK_SUB = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"


@pytest.fixture
def user_no_sub(db: SessionTesting) -> int:
    user = User(
        name="NoSub",
        surname="User",
        hashed_password="x",
        created_at=datetime.now(),
        updated_at=datetime.now(),
    )
    db.add(user)
    db.flush()
    db.add(UserEmail(user_id=user.id, email="nosub@example.com", active=True))
    db.commit()
    return user.id


@pytest.fixture
def user_with_sub(db: SessionTesting) -> int:
    user = User(
        name="WithSub",
        surname="User",
        hashed_password="x",
        authentik_sub=_AUTHENTIK_SUB,
        created_at=datetime.now(),
        updated_at=datetime.now(),
    )
    db.add(user)
    db.flush()
    db.add(UserEmail(user_id=user.id, email="withsub@example.com", active=True))
    db.commit()
    return user.id


# ---------------------------------------------------------------------------
# list_authentik_groups
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_list_groups_no_authentik_token(client: TestClient):
    # AUTHENTIK_TOKEN is "" in test environment
    r = client.get(f"{settings.API_V1_STR}/admin/authentik/groups")
    assert r.status_code == 503


# ---------------------------------------------------------------------------
# add_group_member
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_add_member_user_not_found(client: TestClient):
    r = client.post(f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/99999")
    assert r.status_code == 404


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_add_member_no_authentik_sub(client: TestClient, user_no_sub: int):
    r = client.post(
        f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_no_sub}"
    )
    assert r.status_code == 400


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_add_member_invalid_group_uuid(client: TestClient, user_with_sub: int):
    r = client.post(
        f"{settings.API_V1_STR}/admin/authentik/groups/../../bad/members/{user_with_sub}"
    )
    # FastAPI path parsing may reshape the URL; expect 404 or 422
    assert r.status_code in (404, 422)


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_add_member_success(client: TestClient, user_with_sub: int, monkeypatch):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")

    mock_get_resp = MagicMock()
    mock_get_resp.raise_for_status = MagicMock()
    mock_get_resp.json.return_value = {"results": [{"pk": 42}]}

    mock_post_resp = MagicMock()
    mock_post_resp.status_code = 204

    mock_instance = AsyncMock()
    mock_instance.get.return_value = mock_get_resp
    mock_instance.post.return_value = mock_post_resp

    with patch("app.api.api_v1.admin.httpx.AsyncClient") as mock_cls:
        mock_cls.return_value.__aenter__ = AsyncMock(return_value=mock_instance)
        mock_cls.return_value.__aexit__ = AsyncMock(return_value=False)

        r = client.post(
            f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_with_sub}"
        )

    assert r.status_code == 204


# ---------------------------------------------------------------------------
# remove_group_member
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_remove_member_user_not_found(client: TestClient):
    r = client.delete(f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/99999")
    assert r.status_code == 404


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_remove_member_no_authentik_sub(client: TestClient, user_no_sub: int):
    r = client.delete(
        f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_no_sub}"
    )
    assert r.status_code == 400


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_remove_member_success(client: TestClient, user_with_sub: int, monkeypatch):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")

    mock_get_resp = MagicMock()
    mock_get_resp.raise_for_status = MagicMock()
    mock_get_resp.json.return_value = {"results": [{"pk": 42}]}

    mock_post_resp = MagicMock()
    mock_post_resp.status_code = 204

    mock_instance = AsyncMock()
    mock_instance.get.return_value = mock_get_resp
    mock_instance.post.return_value = mock_post_resp

    with patch("app.api.api_v1.admin.httpx.AsyncClient") as mock_cls:
        mock_cls.return_value.__aenter__ = AsyncMock(return_value=mock_instance)
        mock_cls.return_value.__aexit__ = AsyncMock(return_value=False)

        r = client.delete(
            f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_with_sub}"
        )

    assert r.status_code == 204
