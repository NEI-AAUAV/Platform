from datetime import datetime, timedelta, timezone
from unittest.mock import AsyncMock, patch

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from app.api.api_v1 import admin as admin_module
from app.api.api_v1.admin import _validate_uuid
from app.core.config import settings
from app.models.admin_activity import AdminActivity
from app.models.device_login import DeviceLogin
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
def test_list_groups_no_authentik_token(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "")
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
    ), patch.object(
        admin_module.authentik_client, "list_groups", AsyncMock(return_value=[])
    ):
        r = client.delete(
            f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_with_sub}"
        )

    assert r.status_code == 204


# ---------------------------------------------------------------------------
# role changes: stored scopes and activity
# ---------------------------------------------------------------------------

ADMIN = auth_data(sub=1, scopes=[ScopeEnum.ADMIN])


def _patch_authentik(group_name: str, groups_after: list[dict]):
    client = admin_module.authentik_client
    return (
        patch.object(client, "get_group_name", AsyncMock(return_value=group_name)),
        patch.object(client, "find_user_pk", AsyncMock(return_value=42)),
        patch.object(client, "set_group_membership", AsyncMock(return_value=None)),
        patch.object(client, "list_groups", AsyncMock(return_value=groups_after)),
    )


def _member_url(user_id: int) -> str:
    return f"{settings.API_V1_STR}/admin/authentik/groups/{_GROUP_UUID}/members/{user_id}"


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_removing_a_role_drops_it_from_stored_scopes(
    client: TestClient, db: SessionTesting, user_with_sub: int, monkeypatch
):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")
    user = db.get(User, user_with_sub)
    user.scopes = ["admin", "manager-arraial"]
    db.commit()

    p1, p2, p3, p4 = _patch_authentik("nei-admin", groups_after=[])
    with p1, p2, p3, p4:
        assert client.delete(_member_url(user_with_sub)).status_code == 204

    db.flush()
    db.refresh(user)
    assert user.scopes == ["manager-arraial"]


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_removing_a_role_another_group_still_grants_keeps_it(
    client: TestClient, db: SessionTesting, user_with_sub: int, monkeypatch
):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")
    user = db.get(User, user_with_sub)
    user.scopes = ["admin"]
    db.commit()
    still_in_admin = [{"pk": "x", "name": "admin", "member_subs": [_AUTHENTIK_SUB]}]

    p1, p2, p3, p4 = _patch_authentik("nei-admin", groups_after=still_in_admin)
    with p1, p2, p3, p4:
        assert client.delete(_member_url(user_with_sub)).status_code == 204

    db.flush()
    db.refresh(user)
    assert user.scopes == ["admin"]


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
@pytest.mark.parametrize("method,action", [("post", "role.add"), ("delete", "role.remove")])
def test_role_changes_are_recorded(
    client: TestClient, db: SessionTesting, user_with_sub: int, monkeypatch, method, action
):
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "test-token")

    p1, p2, p3, p4 = _patch_authentik("manager-arraial", groups_after=[])
    with p1, p2, p3, p4:
        assert getattr(client, method)(_member_url(user_with_sub)).status_code == 204

    db.flush()
    entry = db.query(AdminActivity).one()
    assert (entry.action, entry.actor_id, entry.actor_name) == (action, 1, "J C")
    assert (entry.target_user_id, entry.target_name) == (user_with_sub, "WithSub User")
    assert entry.detail == {"role": "manager-arraial"}


# ---------------------------------------------------------------------------
# sign_out_everywhere
# ---------------------------------------------------------------------------


def _add_sessions(db: SessionTesting, user_id: int, count: int) -> None:
    now = datetime.now(timezone.utc)
    for i in range(count):
        db.add(
            DeviceLogin(
                user_id=user_id,
                session_id=1000 + i,
                refreshed_at=now,
                expires_at=now + timedelta(hours=1),
            )
        )
    db.commit()


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_sign_out_everywhere_ends_every_session(
    client: TestClient, db: SessionTesting, user_with_sub: int, user_no_sub: int
):
    _add_sessions(db, user_with_sub, 2)
    _add_sessions(db, user_no_sub, 1)

    r = client.post(f"{settings.API_V1_STR}/admin/users/{user_with_sub}/sign-out")

    assert r.status_code == 200
    assert r.json() == {"sessions_ended": 2}
    db.flush()
    assert db.query(DeviceLogin).filter_by(user_id=user_with_sub).count() == 0
    assert db.query(DeviceLogin).filter_by(user_id=user_no_sub).count() == 1
    entry = db.query(AdminActivity).one()
    assert (entry.action, entry.target_user_id, entry.detail) == (
        "sessions.revoke",
        user_with_sub,
        {"sessions": 2},
    )


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_sign_out_everywhere_unknown_user_is_404(client: TestClient):
    assert client.post(f"{settings.API_V1_STR}/admin/users/99999/sign-out").status_code == 404


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 403)],
    indirect=["client"],
)
@pytest.mark.parametrize(
    "path", ["/admin/users/1/sign-out", "/admin/activity", "/admin/system"]
)
def test_new_admin_endpoints_require_admin(client: TestClient, status_code: int, path: str):
    method = client.post if path.endswith("sign-out") else client.get
    assert method(f"{settings.API_V1_STR}{path}").status_code == status_code


# ---------------------------------------------------------------------------
# list_activity
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_activity_is_listed_newest_first_and_paginated(client: TestClient, db: SessionTesting):
    base = datetime(2026, 9, 1, tzinfo=timezone.utc)
    for i, action in enumerate(["arraial.reset", "role.add", "sessions.revoke"]):
        db.add(
            AdminActivity(
                created_at=base + timedelta(minutes=i),
                actor_id=1,
                actor_name="Ana Admin",
                action=action,
            )
        )
    db.commit()

    first = client.get(f"{settings.API_V1_STR}/admin/activity", params={"limit": 2}).json()
    rest = client.get(
        f"{settings.API_V1_STR}/admin/activity", params={"limit": 2, "offset": 2}
    ).json()

    assert first["total"] == 3
    assert [e["action"] for e in first["items"]] == ["sessions.revoke", "role.add"]
    assert [e["action"] for e in rest["items"]] == ["arraial.reset"]
    assert first["items"][0]["actor_name"] == "Ana Admin"


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_activity_keeps_names_after_the_account_is_deleted(
    client: TestClient, db: SessionTesting, user_no_sub: int
):
    user = db.get(User, user_no_sub)
    admin_module.crud.admin_activity.record(
        db, actor=ADMIN, action="sessions.revoke", target=user
    )
    db.commit()
    db.delete(user)
    db.commit()

    entry = client.get(f"{settings.API_V1_STR}/admin/activity").json()["items"][0]

    assert (entry["target_user_id"], entry["target_name"]) == (user_no_sub, "NoSub User")


# ---------------------------------------------------------------------------
# system_status
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_system_status(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "GIT_COMMIT", "abc1234")
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)
    monkeypatch.setattr(settings, "RECAPTCHA_ENABLED", True)
    monkeypatch.setenv("ENABLED_EXTENSIONS", "rally, gala")

    body = client.get(f"{settings.API_V1_STR}/admin/system").json()

    assert body["commit"] == "abc1234"
    assert body["extensions"] == ["gala", "rally"]
    assert body["integrations"]["email"] is False
    assert body["integrations"]["recaptcha"] is True
    assert body["database"]["current"] is not None
    assert body["database"]["current"] == body["database"]["expected"]


@pytest.mark.parametrize("client", [ADMIN], indirect=True)
def test_system_status_without_commit_or_extension_setting(client: TestClient, monkeypatch):
    monkeypatch.setattr(settings, "GIT_COMMIT", "")
    monkeypatch.delenv("ENABLED_EXTENSIONS", raising=False)

    body = client.get(f"{settings.API_V1_STR}/admin/system").json()

    assert body["commit"] is None
    assert body["extensions"] is None
