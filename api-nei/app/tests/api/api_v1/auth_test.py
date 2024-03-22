from fastapi import FastAPI
import pytest

from fastapi.testclient import TestClient

from datetime import datetime
from jose import jwt

from app.core.config import settings
from app.models import User
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
