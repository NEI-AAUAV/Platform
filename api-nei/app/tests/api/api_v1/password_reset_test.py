"""Contract + business rules for `/auth/forgot` and `/auth/reset`."""

from datetime import datetime, timedelta
from unittest.mock import AsyncMock

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.api.api_v1.auth import _deps as auth_deps
from app.api.api_v1.auth._deps import (
    MAGIC_LINK_TOKEN_TYPE,
    PASSWORD_RESET_TOKEN_TYPE,
    create_token,
    hash_password,
    pwd_context,
)
from app.api.api_v1.auth.reset import _create_password_reset_token
from app.core.config import settings
from app.models import User
from app.models.user.user_email import UserEmail

PREFIX = settings.API_V1_STR
OLD_PASSWORD = "old-password"
NEW_PASSWORD = "brand-new-password"


def _make_user(db: Session, email: str, *, active: bool) -> tuple[User, UserEmail]:
    user = User(
        name="Reset",
        surname="Tester",
        hashed_password=hash_password(OLD_PASSWORD),
        created_at=datetime.fromtimestamp(0),
        updated_at=datetime.fromtimestamp(0),
    )
    db.add(user)
    db.flush()
    user_email = UserEmail(user_id=user.id, email=email, active=active)
    db.add(user_email)
    db.commit()
    return user, user_email


@pytest.fixture
def active_user(db: Session) -> tuple[User, UserEmail]:
    return _make_user(db, "reset-active@test.com", active=True)


@pytest.fixture
def inactive_user(db: Session) -> tuple[User, UserEmail]:
    return _make_user(db, "reset-inactive@test.com", active=False)


@pytest.fixture
def email_enabled(monkeypatch: pytest.MonkeyPatch) -> dict[str, AsyncMock]:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", True)
    sent = {
        "reset": AsyncMock(),
        "changed": AsyncMock(),
    }
    monkeypatch.setattr(
        "app.api.api_v1.auth.reset.emailUtils.send_password_reset", sent["reset"]
    )
    monkeypatch.setattr(
        "app.api.api_v1.auth.reset.emailUtils.send_password_changed", sent["changed"]
    )
    return sent


@pytest.fixture
def email_disabled(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)


def _forgot(client: TestClient, email: str):
    return client.post(f"{PREFIX}/auth/forgot", data={"email": email})


def _reset(client: TestClient, token: str, password: str = NEW_PASSWORD):
    return client.post(
        f"{PREFIX}/auth/reset", params={"token": token}, data={"password": password}
    )


# --- /forgot ---------------------------------------------------------------


def test_forgot_sends_reset_email_with_a_valid_reset_token(
    client: TestClient, active_user, email_enabled
) -> None:
    user, user_email = active_user

    r = _forgot(client, user_email.email)

    assert r.status_code == 200
    assert r.json() == {
        "status": "success",
        "message": "Password reset email sent successfully",
    }
    email_enabled["reset"].assert_awaited_once()
    to, name, token = email_enabled["reset"].await_args.args
    assert (to, name) == (user_email.email, user.name)
    claims = auth_deps.decode_token(token)
    assert claims["type"] == PASSWORD_RESET_TOKEN_TYPE
    assert claims["sub"] == str(user.id)
    assert claims["email"] == user_email.email


def test_forgot_for_unknown_email_fakes_success_without_sending(
    client: TestClient, email_enabled
) -> None:
    """Anti user-enumeration: unknown and known emails look identical."""
    r = _forgot(client, "nobody-here@test.com")

    assert r.status_code == 200
    assert r.json()["status"] == "success"
    email_enabled["reset"].assert_not_awaited()


def test_forgot_rejects_malformed_email(client: TestClient, email_enabled) -> None:
    r = _forgot(client, "not-an-email")

    assert r.status_code == 400
    assert r.json()["detail"] == "Email is invalid"
    email_enabled["reset"].assert_not_awaited()


def test_forgot_rejects_inactive_email(
    client: TestClient, inactive_user, email_enabled
) -> None:
    r = _forgot(client, inactive_user[1].email)

    assert r.status_code == 400
    assert r.json()["detail"] == "Email is not active"
    email_enabled["reset"].assert_not_awaited()


def test_forgot_returns_503_when_email_is_disabled(
    client: TestClient, active_user, email_disabled
) -> None:
    r = _forgot(client, active_user[1].email)

    assert r.status_code == 503
    assert r.json()["detail"] == "Password resets are not enabled"


def test_forgot_requires_email_field(client: TestClient) -> None:
    assert client.post(f"{PREFIX}/auth/forgot", data={}).status_code == 422


# --- /reset ----------------------------------------------------------------


def test_reset_changes_password_and_notifies_user(
    client: TestClient, db: Session, active_user, email_enabled
) -> None:
    user, user_email = active_user
    token = _create_password_reset_token(user.id, user_email.email)

    r = _reset(client, token)

    assert r.status_code == 200
    assert r.json() == {"status": "success", "message": "Password reset successfully"}
    db.refresh(user)
    assert pwd_context.verify(NEW_PASSWORD, user.hashed_password)
    assert not pwd_context.verify(OLD_PASSWORD, user.hashed_password)
    email_enabled["changed"].assert_awaited_once_with(user_email.email, user.name)


def test_reset_does_not_send_notification_when_email_disabled(
    client: TestClient, active_user, email_disabled, monkeypatch
) -> None:
    user, user_email = active_user
    changed = AsyncMock()
    monkeypatch.setattr(
        "app.api.api_v1.auth.reset.emailUtils.send_password_changed", changed
    )

    r = _reset(client, _create_password_reset_token(user.id, user_email.email))

    assert r.status_code == 200
    changed.assert_not_awaited()


def test_reset_then_login_with_new_password(
    client: TestClient, active_user, email_disabled
) -> None:
    user, user_email = active_user
    _reset(client, _create_password_reset_token(user.id, user_email.email))

    ok = client.post(
        f"{PREFIX}/auth/login",
        data={"username": user_email.email, "password": NEW_PASSWORD},
    )
    old = client.post(
        f"{PREFIX}/auth/login",
        data={"username": user_email.email, "password": OLD_PASSWORD},
    )

    assert ok.status_code == 200
    assert old.status_code == 401


def _claims(uid: int, email: str, token_type: str, exp_delta: timedelta) -> dict:
    now = datetime.now()
    return {
        "iat": now,
        "exp": now + exp_delta,
        "sub": str(uid),
        "email": email,
        "type": token_type,
    }


@pytest.mark.parametrize(
    "token",
    ["garbage", "", "a.b.c"],
    ids=["garbage", "empty", "malformed-jwt"],
)
def test_reset_rejects_undecodable_token(client: TestClient, token: str) -> None:
    r = _reset(client, token)

    assert r.status_code == 401
    assert r.json()["detail"] == "Invalid confirmation token"
    assert r.headers["www-authenticate"] == "Reset"


def test_reset_rejects_expired_token(client: TestClient, active_user) -> None:
    user, user_email = active_user
    token = create_token(
        _claims(user.id, user_email.email, PASSWORD_RESET_TOKEN_TYPE, -timedelta(hours=2))
    )

    assert _reset(client, token).status_code == 401


def test_reset_rejects_token_of_another_type(client: TestClient, active_user) -> None:
    """A magic-link token must never be usable as a password-reset token."""
    user, user_email = active_user
    token = create_token(
        _claims(user.id, user_email.email, MAGIC_LINK_TOKEN_TYPE, timedelta(hours=1))
    )

    assert _reset(client, token).status_code == 401


def test_reset_rejects_token_missing_required_claims(
    client: TestClient, active_user
) -> None:
    user, _ = active_user
    now = datetime.now()
    token = create_token(
        {"iat": now, "exp": now + timedelta(hours=1), "sub": str(user.id)}
    )

    assert _reset(client, token).status_code == 401


def test_reset_rejects_non_numeric_subject(client: TestClient) -> None:
    now = datetime.now()
    token = create_token(
        {
            "iat": now,
            "exp": now + timedelta(hours=1),
            "sub": "abc",
            "email": "x@test.com",
            "type": PASSWORD_RESET_TOKEN_TYPE,
        }
    )

    assert _reset(client, token).status_code == 401


def test_reset_rejects_token_whose_email_does_not_belong_to_user(
    client: TestClient, active_user
) -> None:
    user, _ = active_user
    token = _create_password_reset_token(user.id, "someone-else@test.com")

    assert _reset(client, token).status_code == 401


def test_reset_rejects_inactive_email_and_keeps_password(
    client: TestClient, db: Session, inactive_user
) -> None:
    user, user_email = inactive_user
    before = user.hashed_password

    r = _reset(client, _create_password_reset_token(user.id, user_email.email))

    assert r.status_code == 401
    db.refresh(user)
    assert user.hashed_password == before


def test_reset_requires_password_field(client: TestClient, active_user) -> None:
    user, user_email = active_user
    token = _create_password_reset_token(user.id, user_email.email)

    r = client.post(f"{PREFIX}/auth/reset", params={"token": token}, data={})

    assert r.status_code == 422
