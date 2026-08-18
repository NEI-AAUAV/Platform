from fastapi import FastAPI
import pytest

from fastapi.testclient import TestClient

from datetime import datetime, timedelta, timezone
from jose import jwt

from app.core.config import settings
from app.models import User
from app.models.device_login import DeviceLogin
from app.models.user.user_email import UserEmail
from app.tests.conftest import SessionTesting
from app.api.api_v1.auth.register import _create_email_verification_token
from app.api.api_v1.auth._deps import Token, hash_password

user_password = "test_password"
user = {
    "name": "Test",
    "surname": "User",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0),
    "updated_at": datetime.fromtimestamp(0),
}
userEmail = "testUser@test.com"

expiredUser = {
    "name": "Test",
    "surname": "User Expired",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "updated_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
}
expiredUserEmail = "testUserExpired@test.com"

inactiveUser = {
    "name": "Test",
    "surname": "User Inactive",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "updated_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
}
inactiveUserEmail = "testUserInactive@test.com"


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""
    user_obj = User(**user)
    db.add(user_obj)
    db.flush()
    db.add(UserEmail(user_id=user_obj.id, email=userEmail, active=True))

    expired_user_obj = User(**expiredUser)
    db.add(expired_user_obj)
    db.flush()
    db.add(UserEmail(user_id=expired_user_obj.id, email=expiredUserEmail, active=False))

    inactive_user_obj = User(**inactiveUser)
    db.add(inactive_user_obj)
    db.flush()
    db.add(
        UserEmail(user_id=inactive_user_obj.id, email=inactiveUserEmail, active=False)
    )

    db.commit()


def get_by_email(db: SessionTesting, email: str) -> tuple[User, UserEmail]:
    return (
        db.query(User, UserEmail)
        .filter(User.id == UserEmail.user_id, UserEmail.email == email)
        .first()
    )


def test_register(db: SessionTesting, client: TestClient) -> None:
    email = "testUser2@test.com"

    matches = get_by_email(db, email)
    assert matches is None

    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": "Test",
            "surname": "User 2",
            "email": email,
            "password": "test_password",
        },
        follow_redirects=True,
    )
    assert r.status_code == 200
    data = r.json()
    token = Token(**data)
    assert token.token_type == "bearer"
    assert r.cookies["refresh"] is not None

    matches = get_by_email(db, email)
    assert matches is not None


def test_register_conflict(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": user["name"],
            "surname": user["surname"],
            "email": userEmail,
            "password": "test_password",
        },
        follow_redirects=True,
    )
    assert r.status_code == 409


def test_register_invalid_email(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": user["name"],
            "surname": user["surname"],
            "email": "test",
            "password": "test_password",
        },
        follow_redirects=True,
    )
    assert r.status_code == 400


def test_register_short_password(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": user["name"],
            "surname": user["surname"],
            "email": userEmail,
            "password": "short",
        },
        follow_redirects=True,
    )
    assert r.status_code == 422


def test_register_replace_expired(db: SessionTesting, client: TestClient) -> None:
    matches = get_by_email(db, expiredUserEmail)
    assert matches is not None

    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": expiredUser["surname"] + "NEW",
            "surname": expiredUser["surname"],
            "email": expiredUserEmail,
            "password": user_password,
        },
        follow_redirects=True,
    )
    assert r.status_code == 200
    data = r.json()
    token = Token(**data)
    assert token.token_type == "bearer"

    matches = get_by_email(db, expiredUserEmail)
    assert matches is not None
    assert matches[0].name == expiredUser["surname"] + "NEW"


def test_login(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": userEmail,
            "password": user_password,
        },
        follow_redirects=True,
    )
    assert r.status_code == 200
    data = r.json()
    token = Token(**data)
    assert token.token_type == "bearer"
    assert r.cookies["refresh"] is not None


def test_login_wrong_password(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": userEmail,
            "password": user_password + "bad",
        },
        follow_redirects=True,
    )
    assert r.status_code == 401


def test_login_wrong_email(db: SessionTesting, client: TestClient) -> None:
    matches = get_by_email(db, userEmail + "bad")
    assert matches is None

    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": userEmail + "bad",
            "password": user_password,
        },
        follow_redirects=True,
    )
    assert r.status_code == 401


def test_refresh(db: SessionTesting, app: FastAPI, client: TestClient) -> None:
    r1 = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": userEmail,
            "password": user_password,
        },
        follow_redirects=True,
    )
    assert r1.status_code == 200
    assert r1.cookies["refresh"] is not None

    authed_client = TestClient(app, cookies={"refresh": r1.cookies["refresh"]})
    r2 = authed_client.post(
        f"{settings.API_V1_STR}/auth/refresh/",
        follow_redirects=True,
    )
    assert r2.status_code == 200
    data = r2.json()
    token = Token(**data)
    assert token.token_type == "bearer"
    assert r2.cookies["refresh"] is not None

    r1_token = jwt.get_unverified_claims(r1.cookies["refresh"])
    r2_token = jwt.get_unverified_claims(r2.cookies["refresh"])
    assert r1_token["exp"] == r2_token["exp"]
    assert r1_token["sub"] == r2_token["sub"]


def test_verify(db: SessionTesting, client: TestClient) -> None:
    matches = get_by_email(db, inactiveUserEmail)

    assert matches is not None
    assert not matches[1].active

    token = _create_email_verification_token(matches[0].id, matches[1].email)

    r = client.get(
        f"{settings.API_V1_STR}/auth/verify/?token={token}",
        follow_redirects=True,
    )
    assert r.status_code == 200

    matches = get_by_email(db, inactiveUserEmail)
    assert matches is not None
    assert matches[1].active


def _login(client: TestClient) -> str:
    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={"username": userEmail, "password": user_password},
        follow_redirects=True,
    )
    assert r.status_code == 200
    return r.cookies["refresh"]


def test_logout_clears_cookie_with_matching_path(app: FastAPI, client: TestClient) -> None:
    refresh = _login(client)

    r = TestClient(app, cookies={"refresh": refresh}).post(
        f"{settings.API_V1_STR}/auth/logout/",
        follow_redirects=True,
    )

    assert r.status_code == 200
    set_cookie = r.headers["set-cookie"]
    # Cookie identity is (name, domain, path): a deletion at the default "/"
    # would create a second slot and leave the real cookie in place.
    assert f"Path={settings.API_V1_STR}/auth" in set_cookie
    assert "Max-Age=0" in set_cookie


def test_logout_with_invalid_cookie_still_clears(app: FastAPI) -> None:
    r = TestClient(app, cookies={"refresh": "not-a-jwt"}).post(
        f"{settings.API_V1_STR}/auth/logout/",
        follow_redirects=True,
    )

    assert r.status_code == 401
    set_cookie = r.headers["set-cookie"]
    assert f"Path={settings.API_V1_STR}/auth" in set_cookie
    assert "Max-Age=0" in set_cookie


def test_logout_invalidates_session(app: FastAPI, client: TestClient) -> None:
    refresh = _login(client)
    authed_client = TestClient(app, cookies={"refresh": refresh})

    assert authed_client.post(
        f"{settings.API_V1_STR}/auth/logout/", follow_redirects=True
    ).status_code == 200

    replayed = TestClient(app, cookies={"refresh": refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh/",
        follow_redirects=True,
    )
    assert replayed.status_code == 401


def _session_row(db: SessionTesting, refresh: str) -> DeviceLogin:
    claims = jwt.get_unverified_claims(refresh)
    row = db.get(DeviceLogin, (int(claims["sub"]), int(claims["sid"])))
    assert row is not None
    return row


def test_refresh_under_non_utc_timezone(
    db: SessionTesting, app: FastAPI, client: TestClient, monkeypatch
) -> None:
    """Expiry used to be compared against naive local time while the column
    stored UTC, so under WEST a live session was rejected an hour early."""
    import time

    refresh = _login(client)
    row = _session_row(db, refresh)
    row.expires_at = datetime.now(timezone.utc) + timedelta(minutes=30)
    db.commit()

    monkeypatch.setenv("TZ", "Europe/Lisbon")
    time.tzset()
    try:
        r = TestClient(app, cookies={"refresh": refresh}).post(
            f"{settings.API_V1_STR}/auth/refresh",
            follow_redirects=True,
        )
        assert r.status_code == 200
    finally:
        monkeypatch.undo()
        time.tzset()


def test_expired_session_is_rejected(
    db: SessionTesting, app: FastAPI, client: TestClient
) -> None:
    refresh = _login(client)
    row = _session_row(db, refresh)
    row.expires_at = datetime.now(timezone.utc) - timedelta(seconds=1)
    db.commit()

    r = TestClient(app, cookies={"refresh": refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert r.status_code == 401


def test_refresh_rotates_jti(db: SessionTesting, app: FastAPI, client: TestClient) -> None:
    r1_refresh = _login(client)
    r2 = TestClient(app, cookies={"refresh": r1_refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert r2.status_code == 200

    jti1 = jwt.get_unverified_claims(r1_refresh)["jti"]
    jti2 = jwt.get_unverified_claims(r2.cookies["refresh"])["jti"]
    assert jti1 != jti2
    assert _session_row(db, r1_refresh).refresh_jti == jti2


def test_refresh_replay_kills_session(
    db: SessionTesting, app: FastAPI, client: TestClient
) -> None:
    r1_refresh = _login(client)
    claims = jwt.get_unverified_claims(r1_refresh)

    assert TestClient(app, cookies={"refresh": r1_refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh", follow_redirects=True
    ).status_code == 200

    replayed = TestClient(app, cookies={"refresh": r1_refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert replayed.status_code == 401
    # The whole session is torn down, not just this request rejected.
    assert db.get(DeviceLogin, (int(claims["sub"]), int(claims["sid"]))) is None


def test_refresh_replay_detected_within_same_second(
    db: SessionTesting, app: FastAPI, client: TestClient, monkeypatch
) -> None:
    """The old check compared whole-second timestamps, so a token replayed in
    the same second it was issued slipped through."""
    from app.api.api_v1.auth import _deps

    frozen = datetime.now(timezone.utc)
    monkeypatch.setattr(_deps, "datetime", _FrozenDatetime(frozen))

    r1_refresh = _login(client)
    assert TestClient(app, cookies={"refresh": r1_refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh", follow_redirects=True
    ).status_code == 200

    replayed = TestClient(app, cookies={"refresh": r1_refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert replayed.status_code == 401


def test_pre_migration_session_heals(
    db: SessionTesting, app: FastAPI, client: TestClient
) -> None:
    """A session created before the jti migration has no stored jti and its
    token carries no jti claim; it must refresh once and gain one."""
    refresh = _login(client)
    row = _session_row(db, refresh)
    row.refresh_jti = None
    db.commit()

    claims = jwt.get_unverified_claims(refresh)
    legacy_token = _legacy_refresh_token(claims)

    r = TestClient(app, cookies={"refresh": legacy_token}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert r.status_code == 200
    assert _session_row(db, refresh).refresh_jti is not None


def test_pre_migration_row_rejects_token_with_jti(
    db: SessionTesting, app: FastAPI, client: TestClient
) -> None:
    """Closes the downgrade path: a jti-bearing token must not be accepted
    against a row that has no jti yet."""
    refresh = _login(client)
    row = _session_row(db, refresh)
    row.refresh_jti = None
    db.commit()

    r = TestClient(app, cookies={"refresh": refresh}).post(
        f"{settings.API_V1_STR}/auth/refresh",
        follow_redirects=True,
    )
    assert r.status_code == 401


class _FrozenDatetime:
    """Pins datetime.now() so login and refresh share one `iat`."""

    def __init__(self, value: datetime) -> None:
        self._value = value

    def now(self, tz=None) -> datetime:
        return self._value


def _legacy_refresh_token(claims: dict) -> str:
    """Mint a refresh token in the pre-migration format, without a jti."""
    from app.api.api_v1.auth._deps import REFRESH_TOKEN_TYPE, create_token

    return create_token(
        {
            "iat": claims["iat"],
            "exp": claims["exp"],
            "sub": claims["sub"],
            "type": REFRESH_TOKEN_TYPE,
            "sid": claims["sid"],
        }
    )
