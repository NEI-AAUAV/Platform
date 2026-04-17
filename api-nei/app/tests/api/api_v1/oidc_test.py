from datetime import datetime
from unittest.mock import patch

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient
from sqlalchemy.exc import IntegrityError

from app.api.api_v1.auth.oidc import (
    _is_safe_redirect,
    _parse_name,
    _parse_scopes,
    get_or_create_user_from_oidc,
)
from app.core.config import settings
from app.models.user import User
from app.models.user.user_email import UserEmail
from app.schemas.user import ScopeEnum
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting


# ---------------------------------------------------------------------------
# _parse_scopes
# ---------------------------------------------------------------------------


def test_parse_scopes_from_list():
    result = _parse_scopes({"scopes": ["default", "admin"]})
    assert set(result) == {"default", "admin"}


def test_parse_scopes_from_string():
    result = _parse_scopes({"scopes": "default admin"})
    assert set(result) == {"default", "admin"}


def test_parse_scopes_from_groups():
    result = _parse_scopes({"groups": ["nei-admin"]})
    assert "admin" in result


def test_parse_scopes_strips_nei_prefix():
    result = _parse_scopes({"groups": ["nei-default"]})
    assert result == ["default"]


def test_parse_scopes_filters_invalid():
    result = _parse_scopes({"scopes": ["totally_invalid", "default"]})
    assert "default" in result
    assert "totally_invalid" not in result


def test_parse_scopes_all_invalid_returns_default():
    result = _parse_scopes({"scopes": ["totally_invalid"]})
    assert result == ["default"]


def test_parse_scopes_empty_returns_default():
    result = _parse_scopes({})
    assert result == ["default"]


# ---------------------------------------------------------------------------
# _parse_name
# ---------------------------------------------------------------------------


def test_parse_name_uses_first_last():
    name, surname = _parse_name({"first_name": "John", "last_name": "Doe"})
    assert name == "John"
    assert surname == "Doe"


def test_parse_name_falls_back_to_name_field():
    name, surname = _parse_name({"name": "John Doe"})
    assert name == "John"
    assert surname == "Doe"


def test_parse_name_single_word_fallback():
    name, surname = _parse_name({"name": "John"})
    assert name == "John"
    assert surname == ""


def test_parse_name_empty_returns_placeholder():
    name, _ = _parse_name({})
    assert name == "User"


def test_parse_name_truncates_to_20():
    name, _ = _parse_name({"first_name": "A" * 30, "last_name": ""})
    assert len(name) == 20


# ---------------------------------------------------------------------------
# get_or_create_user_from_oidc
# ---------------------------------------------------------------------------

_USERINFO = {
    "sub": "oidc-sub-test-001",
    "email": "oidctest@example.com",
    "email_verified": True,
    "first_name": "Alice",
    "last_name": "Doe",
    "scopes": ["default"],
}


def test_get_or_create_creates_new_user(db: SessionTesting):
    user = get_or_create_user_from_oidc(db, _USERINFO)
    assert user.id is not None
    assert user.name == "Alice"
    assert user.surname == "Doe"
    assert user.authentik_sub == "oidc-sub-test-001"
    assert user.scopes == ["default"]


def test_get_or_create_returns_existing_user_by_sub(db: SessionTesting):
    u1 = get_or_create_user_from_oidc(db, _USERINFO)
    # Same sub, different email — must return the same user
    u2 = get_or_create_user_from_oidc(db, {**_USERINFO, "email": "other@example.com"})
    assert u1.id == u2.id


def test_get_or_create_links_existing_user_by_email(db: SessionTesting):
    existing = User(
        name="Bob",
        surname="Smith",
        hashed_password="hashed",
        created_at=datetime.now(),
        updated_at=datetime.now(),
    )
    db.add(existing)
    db.flush()
    db.add(UserEmail(user_id=existing.id, email="bob@example.com", active=True))
    db.commit()

    userinfo = {**_USERINFO, "sub": "new-sub-for-bob", "email": "bob@example.com"}
    linked = get_or_create_user_from_oidc(db, userinfo)
    assert linked.id == existing.id
    assert linked.authentik_sub == "new-sub-for-bob"


def test_get_or_create_syncs_name_on_relogin(db: SessionTesting):
    get_or_create_user_from_oidc(db, _USERINFO)
    updated = get_or_create_user_from_oidc(
        db, {**_USERINFO, "first_name": "Alicia", "last_name": "Doe"}
    )
    assert updated.name == "Alicia"


def test_get_or_create_missing_sub_raises_400(db: SessionTesting):
    with pytest.raises(HTTPException) as exc:
        get_or_create_user_from_oidc(db, {"email": "x@example.com"})
    assert exc.value.status_code == 400


def test_get_or_create_missing_email_raises_400(db: SessionTesting):
    with pytest.raises(HTTPException) as exc:
        get_or_create_user_from_oidc(db, {"sub": "some-sub"})
    assert exc.value.status_code == 400


def test_get_or_create_rejects_unverified_email(db: SessionTesting):
    userinfo = {**_USERINFO, "email_verified": False}
    with pytest.raises(HTTPException) as exc:
        get_or_create_user_from_oidc(db, userinfo)
    assert exc.value.status_code == 403


def test_get_or_create_rejects_missing_email_verified_claim(db: SessionTesting):
    userinfo = {k: v for k, v in _USERINFO.items() if k != "email_verified"}
    with pytest.raises(HTTPException) as exc:
        get_or_create_user_from_oidc(db, userinfo)
    assert exc.value.status_code == 403


def test_get_or_create_race_condition_returns_existing_user(db: SessionTesting):
    # Simulate two concurrent first-logins for the same user: the second INSERT
    # hits a unique-constraint violation (IntegrityError). The handler must
    # roll back and return the row committed by the first request.
    u1 = get_or_create_user_from_oidc(db, _USERINFO)

    with patch("app.crud.user.create", side_effect=IntegrityError("", {}, None)):
        u2 = get_or_create_user_from_oidc(db, _USERINFO)

    assert u1.id == u2.id


def test_get_or_create_does_not_auto_link_when_email_unverified(db: SessionTesting):
    # If an attacker registers in the IDP with a victim's email but hasn't
    # verified it, they must not be auto-linked to the victim's platform account.
    existing = User(
        name="Victim",
        surname="User",
        hashed_password="hashed",
        created_at=datetime.now(),
        updated_at=datetime.now(),
    )
    db.add(existing)
    db.flush()
    db.add(UserEmail(user_id=existing.id, email="victim@example.com", active=True))
    db.commit()

    attacker_userinfo = {
        **_USERINFO,
        "sub": "attacker-sub",
        "email": "victim@example.com",
        "email_verified": False,
    }
    with pytest.raises(HTTPException) as exc:
        get_or_create_user_from_oidc(db, attacker_userinfo)
    assert exc.value.status_code == 403

    db.refresh(existing)
    assert existing.authentik_sub is None


# ---------------------------------------------------------------------------
# _is_safe_redirect
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("value", ["/", "/dashboard", "/auth/login?x=1", "/a/b/c"])
def test_is_safe_redirect_accepts_relative_paths(value):
    assert _is_safe_redirect(value) is True


@pytest.mark.parametrize(
    "value",
    [
        None,
        "",
        "dashboard",            # no leading slash
        "//evil.com",           # protocol-relative
        "/\\evil.com",          # backslash variant
        "http://evil.com",
        "https://evil.com/x",
        "javascript:alert(1)",
        "/\tevil.com",          # tab confusion
        "/ /evil.com",          # space confusion
        "/\nevil.com",          # newline confusion
    ],
)
def test_is_safe_redirect_rejects_unsafe_values(value):
    assert _is_safe_redirect(value) is False


# ---------------------------------------------------------------------------
# manager-gamification scope is recognized
# ---------------------------------------------------------------------------


def test_parse_scopes_accepts_manager_gamification():
    result = _parse_scopes({"scopes": ["manager-gamification"]})
    assert result == ["manager-gamification"]


# ---------------------------------------------------------------------------
# OIDC disabled endpoints (OIDC_ENABLED=False is the default in test config)
# ---------------------------------------------------------------------------


def test_oidc_login_disabled(client: TestClient):
    r = client.get(
        f"{settings.API_V1_STR}/auth/oidc/login",
        follow_redirects=False,
    )
    assert r.status_code == 503


def test_oidc_callback_disabled(client: TestClient):
    r = client.get(
        f"{settings.API_V1_STR}/auth/oidc/callback",
        params={"code": "dummy", "state": "dummy"},
        follow_redirects=False,
    )
    assert r.status_code == 503


@pytest.mark.parametrize("client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True)
def test_oidc_link_disabled(client: TestClient):
    r = client.post(
        f"{settings.API_V1_STR}/auth/oidc/link",
        follow_redirects=False,
    )
    assert r.status_code == 503


def test_oidc_link_callback_disabled(client: TestClient):
    r = client.get(
        f"{settings.API_V1_STR}/auth/oidc/link-callback",
        params={"code": "dummy", "state": "dummy"},
        follow_redirects=False,
    )
    assert r.status_code == 503
