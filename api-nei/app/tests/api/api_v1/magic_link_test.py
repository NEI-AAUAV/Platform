"""Contract + business rules for magic-link activation (`/auth/magic`)."""

from datetime import datetime, timedelta
from unittest.mock import AsyncMock, MagicMock

import pytest
from fastapi import BackgroundTasks
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.api.api_v1.auth import _deps as auth_deps
from app.api.api_v1.auth import magic_link as ml
from app.api.api_v1.auth._deps import (
    MAGIC_LINK_TOKEN_TYPE,
    PASSWORD_RESET_TOKEN_TYPE,
    create_token,
    pwd_context,
)
from app.core.config import settings
from app.models import User
from app.models.user.user_email import UserEmail

PREFIX = settings.API_V1_STR
PASSWORD = "magic-password-123"


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


def _make_user(db: Session, email: str, *, active: bool) -> tuple[User, UserEmail]:
    user = User(
        name="Magic",
        surname="Tester",
        hashed_password=None,
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
def pending_user(db: Session) -> tuple[User, UserEmail]:
    return _make_user(db, "magic-pending@test.com", active=False)


@pytest.fixture
def active_user(db: Session) -> tuple[User, UserEmail]:
    return _make_user(db, "magic-active@test.com", active=True)


def _activate(client: TestClient, token: str, password: str = PASSWORD):
    return client.post(
        f"{PREFIX}/auth/magic", params={"token": token}, data={"password": password}
    )


# --- token generation ------------------------------------------------------


def test_created_token_carries_identity_type_and_expiry() -> None:
    token = ml._create_magic_link_token(7, "a@b.com")

    claims = auth_deps.decode_token(token)
    assert claims["sub"] == "7"
    assert claims["email"] == "a@b.com"
    assert claims["type"] == MAGIC_LINK_TOKEN_TYPE
    lifetime = claims["exp"] - claims["iat"]
    assert lifetime == int(settings.MAGIC_LINK_TOKEN_EXPIRE.total_seconds())


@pytest.mark.anyio
async def test_send_magic_link_token_emails_a_magic_token(monkeypatch) -> None:
    send = AsyncMock()
    monkeypatch.setattr(ml.emailUtils, "send_magic_link", send)

    await ml._send_magic_link_token("a@b.com", "Ann", 3, "Welcome to X")

    send.assert_awaited_once()
    to, name, reason, token = send.await_args.args
    assert (to, name, reason) == ("a@b.com", "Ann", "Welcome to X")
    assert auth_deps.decode_token(token)["type"] == MAGIC_LINK_TOKEN_TYPE


def test_send_magic_link_schedules_email_when_enabled(monkeypatch) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", True)
    tasks = MagicMock(spec=BackgroundTasks)
    user = MagicMock(id=5)
    user.name = "Ann"

    ml.send_magic_link(user, "a@b.com", tasks, "reason")

    tasks.add_task.assert_called_once_with(
        ml._send_magic_link_token, "a@b.com", "Ann", 5, "reason"
    )


def test_send_magic_link_is_noop_when_email_disabled(monkeypatch) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)
    tasks = MagicMock(spec=BackgroundTasks)

    ml.send_magic_link(MagicMock(id=1), "a@b.com", tasks, "reason")

    tasks.add_task.assert_not_called()


# --- activation endpoint ---------------------------------------------------


def test_activation_sets_password_and_activates_email(
    client: TestClient, db: Session, pending_user, monkeypatch
) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)
    user, user_email = pending_user

    r = _activate(client, ml._create_magic_link_token(user.id, user_email.email))

    assert r.status_code == 200
    assert r.json() == {"status": "success", "message": "Password set successfully"}
    db.refresh(user)
    db.refresh(user_email)
    assert user_email.active is True
    assert pwd_context.verify(PASSWORD, user.hashed_password)


def test_activation_allows_login_afterwards(
    client: TestClient, pending_user, monkeypatch
) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)
    user, user_email = pending_user
    before = client.post(
        f"{PREFIX}/auth/login",
        data={"username": user_email.email, "password": PASSWORD},
    )
    assert before.status_code == 401

    _activate(client, ml._create_magic_link_token(user.id, user_email.email))

    after = client.post(
        f"{PREFIX}/auth/login",
        data={"username": user_email.email, "password": PASSWORD},
    )
    assert after.status_code == 200


def test_activation_notifies_user_when_email_enabled(
    client: TestClient, pending_user, monkeypatch
) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", True)
    changed = AsyncMock()
    monkeypatch.setattr(ml.emailUtils, "send_password_changed", changed)
    user, user_email = pending_user

    r = _activate(client, ml._create_magic_link_token(user.id, user_email.email))

    assert r.status_code == 200
    changed.assert_awaited_once_with(user_email.email, user.name)


def test_token_is_single_use(client: TestClient, pending_user, monkeypatch) -> None:
    monkeypatch.setattr(settings, "EMAIL_ENABLED", False)
    user, user_email = pending_user
    token = ml._create_magic_link_token(user.id, user_email.email)

    first = _activate(client, token)
    second = _activate(client, token, password="attacker-password")

    assert first.status_code == 200
    assert second.status_code == 400
    assert second.json()["detail"] == "Email is already active"


def test_activation_of_already_active_account_keeps_password(
    client: TestClient, db: Session, active_user
) -> None:
    user, user_email = active_user
    user.hashed_password = "original-hash"
    db.commit()

    r = _activate(client, ml._create_magic_link_token(user.id, user_email.email))

    assert r.status_code == 400
    db.refresh(user)
    assert user.hashed_password == "original-hash"


def _claims(uid: int, email: str, token_type: str, exp_delta: timedelta) -> dict:
    now = datetime.now()
    return {
        "iat": now,
        "exp": now + exp_delta,
        "sub": str(uid),
        "email": email,
        "type": token_type,
    }


@pytest.mark.parametrize("token", ["garbage", "", "a.b.c"])
def test_activation_rejects_undecodable_token(client: TestClient, token: str) -> None:
    r = _activate(client, token)

    assert r.status_code == 401
    assert r.json()["detail"] == "Invalid token"


def test_activation_rejects_expired_token(client: TestClient, pending_user) -> None:
    user, user_email = pending_user
    token = create_token(
        _claims(user.id, user_email.email, MAGIC_LINK_TOKEN_TYPE, -timedelta(days=2))
    )

    assert _activate(client, token).status_code == 401


def test_activation_rejects_password_reset_token(
    client: TestClient, pending_user
) -> None:
    user, user_email = pending_user
    token = create_token(
        _claims(user.id, user_email.email, PASSWORD_RESET_TOKEN_TYPE, timedelta(hours=1))
    )

    assert _activate(client, token).status_code == 401


def test_activation_rejects_token_missing_claims(
    client: TestClient, pending_user
) -> None:
    user, _ = pending_user
    now = datetime.now()
    token = create_token(
        {"iat": now, "exp": now + timedelta(hours=1), "sub": str(user.id)}
    )

    assert _activate(client, token).status_code == 401


def test_activation_rejects_unknown_user(client: TestClient) -> None:
    token = ml._create_magic_link_token(999_999_999, "ghost@test.com")

    assert _activate(client, token).status_code == 401


def test_activation_rejects_email_not_owned_by_user(
    client: TestClient, pending_user
) -> None:
    user, _ = pending_user
    token = ml._create_magic_link_token(user.id, "other@test.com")

    assert _activate(client, token).status_code == 401


def test_activation_requires_password(client: TestClient, pending_user) -> None:
    user, user_email = pending_user
    token = ml._create_magic_link_token(user.id, user_email.email)

    r = client.post(f"{PREFIX}/auth/magic", params={"token": token}, data={})

    assert r.status_code == 422
