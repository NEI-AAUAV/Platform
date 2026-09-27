from datetime import datetime
from unittest.mock import AsyncMock, patch

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from app.api.api_v1 import admin as admin_module
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
# cms_info
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_cms_info_links_to_the_directus_app(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "DIRECTUS_PUBLIC_URL", "https://nei.example.org/cms/")

    r = client.get(f"{settings.API_V1_STR}/admin/cms")

    assert r.status_code == 200
    assert r.json() == {"app_url": "https://nei.example.org/cms/admin/"}


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 403)],
    indirect=["client"],
)
def test_cms_info_requires_admin(client: TestClient, status_code: int):
    r = client.get(f"{settings.API_V1_STR}/admin/cms")

    assert r.status_code == status_code


# ---------------------------------------------------------------------------
# authentik_status
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_status_reports_authentik_setup(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "OIDC_ENABLED", True)
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret-token")
    monkeypatch.setattr(settings, "AUTHENTIK_URL", "https://sso.example.org/authentik/")

    r = client.get(f"{settings.API_V1_STR}/admin/authentik/status")

    assert r.status_code == 200
    assert r.json() == {
        "oidc_enabled": True,
        "groups_managed": True,
        "admin_url": "https://sso.example.org/authentik/if/admin/",
    }


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_status_without_token_reports_groups_unmanaged(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "OIDC_ENABLED", False)
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "")

    body = client.get(f"{settings.API_V1_STR}/admin/authentik/status").json()

    assert body["oidc_enabled"] is False
    assert body["groups_managed"] is False


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_status_never_exposes_the_token(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret-token")

    r = client.get(f"{settings.API_V1_STR}/admin/authentik/status")

    assert "secret-token" not in r.text


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 403)],
    indirect=["client"],
)
def test_status_requires_admin(client: TestClient, status_code: int):
    r = client.get(f"{settings.API_V1_STR}/admin/authentik/status")

    assert r.status_code == status_code


# ---------------------------------------------------------------------------
# list_authentik_groups
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_list_groups_no_authentik_token(client: TestClient):
    # AUTHENTIK_TOKEN is "" in test environment
    r = client.get(f"{settings.API_V1_STR}/admin/authentik/groups")
    assert r.status_code == 503


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_list_groups_only_returns_groups_that_grant_a_role(client: TestClient):
    upstream = [
        {"pk": "1", "name": "nei-admin", "member_subs": ["a"]},
        {"pk": "2", "name": "manager-arraial", "member_subs": []},
        {"pk": "3", "name": "cms-manager", "member_subs": ["b"]},
        {"pk": "4", "name": "authentik Admins", "member_subs": ["a"]},
        {"pk": "5", "name": "authentik Read-only", "member_subs": []},
        {"pk": "6", "name": "default", "member_subs": []},
        {"pk": "7", "name": "book-club", "member_subs": []},
    ]
    with patch.object(admin_module.authentik_client, "list_groups", AsyncMock(return_value=upstream)):
        r = client.get(f"{settings.API_V1_STR}/admin/authentik/groups")

    assert r.status_code == 200
    assert [(g["name"], g["role"]) for g in r.json()] == [
        ("nei-admin", "admin"),
        ("manager-arraial", "manager-arraial"),
        ("cms-manager", "cms-manager"),
    ]


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
@pytest.mark.parametrize("method", ["post", "delete"])
@pytest.mark.parametrize("group_name", ["authentik Admins", "authentik Read-only", "default"])
def test_membership_of_groups_without_a_role_is_refused(
    client: TestClient, user_with_sub: int, monkeypatch, method: str, group_name: str
):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")
    set_membership = AsyncMock(return_value=None)

    with patch.object(
        admin_module.authentik_client, "get_group_name", AsyncMock(return_value=group_name)
    ), patch.object(
        admin_module.authentik_client, "find_user_pk", AsyncMock(return_value=42)
    ), patch.object(admin_module.authentik_client, "set_group_membership", set_membership):
        r = getattr(client, method)(
            f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_with_sub}"
        )

    assert r.status_code == 403
    set_membership.assert_not_awaited()


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

    with patch.object(
        __import__("app.api.api_v1.admin", fromlist=["authentik_client"]).authentik_client,
        "find_user_pk",
        AsyncMock(return_value=42),
    ), patch.object(
        __import__("app.api.api_v1.admin", fromlist=["authentik_client"]).authentik_client,
        "set_group_membership",
        AsyncMock(return_value=None),
    ), patch.object(
        admin_module.authentik_client,
        "get_group_name",
        AsyncMock(return_value="nei-manager-arraial"),
    ):
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

    with patch.object(
        __import__("app.api.api_v1.admin", fromlist=["authentik_client"]).authentik_client,
        "find_user_pk",
        AsyncMock(return_value=42),
    ), patch.object(
        __import__("app.api.api_v1.admin", fromlist=["authentik_client"]).authentik_client,
        "set_group_membership",
        AsyncMock(return_value=None),
    ), patch.object(
        admin_module.authentik_client,
        "get_group_name",
        AsyncMock(return_value="nei-manager-arraial"),
    ):
        r = client.delete(
            f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_with_sub}"
        )

    assert r.status_code == 204
