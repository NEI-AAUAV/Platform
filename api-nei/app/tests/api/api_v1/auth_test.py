import pytest

from fastapi.testclient import TestClient

from datetime import datetime
from jose import jwt

from app.core.config import settings
from app.models import User
from app.tests.conftest import SessionTesting
from app.api.api_v1.auth.register import _create_email_verification_token
from app.api.api_v1.auth._deps import Token, hash_password

user_password = "test_password"
user = {
    "name": "Test",
    "surname": "User",
    "email": "testUser@test.com",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0),
    "updated_at": datetime.fromtimestamp(0),
    "active": True,
}

expiredUser = {
    "name": "Test",
    "surname": "User Expired",
    "email": "testUserExpired@test.com",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "updated_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "active": False,
}

inactiveUser = {
    "name": "Test",
    "surname": "User Inactive",
    "email": "testUserInactive@test.com",
    "hashed_password": hash_password(user_password),
    "created_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "updated_at": datetime.fromtimestamp(0) - settings.CONFIRMATION_TOKEN_EXPIRE,
    "active": False,
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""
    db.add(User(**user))
    db.add(User(**expiredUser))
    db.add(User(**inactiveUser))
    db.commit()


def test_register(db: SessionTesting, client: TestClient) -> None:
    email = "testUser2@test.com"

    matches = db.query(User).filter(User.email == email).first()
    assert matches is None

    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": "Test",
            "surname": "User 2",
            "email": email,
            "password": "test_password",
        },
        allow_redirects=True,
    )
    assert r.status_code == 200
    data = r.json()
    token = Token(**data)
    assert token.token_type == "bearer"
    assert r.cookies["refresh"] is not None

    matches = db.query(User).filter(User.email == email).first()
    assert matches is not None


def test_register_conflict(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": user["name"],
            "surname": user["surname"],
            "email": user["email"],
            "password": "test_password",
        },
        allow_redirects=True,
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
        allow_redirects=True,
    )
    assert r.status_code == 400


def test_register_short_password(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": user["name"],
            "surname": user["surname"],
            "email": user["email"],
            "password": "short",
        },
        allow_redirects=True,
    )
    assert r.status_code == 422


def test_register_replace_expired(db: SessionTesting, client: TestClient) -> None:
    matches = db.query(User).filter(User.email == expiredUser["email"]).first()
    assert matches is not None

    r = client.post(
        f"{settings.API_V1_STR}/auth/register/",
        json={
            "name": expiredUser["surname"] + "NEW",
            "surname": expiredUser["surname"],
            "email": expiredUser["email"],
            "password": user_password,
        },
        allow_redirects=True,
    )
    assert r.status_code == 200
    data = r.json()
    token = Token(**data)
    assert token.token_type == "bearer"

    matches = db.query(User).filter(User.email == expiredUser["email"]).first()
    assert matches is not None
    assert matches.name == expiredUser["surname"] + "NEW"


def test_login(db: SessionTesting, client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": user["email"],
            "password": user_password,
        },
        allow_redirects=True,
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
            "username": user["email"],
            "password": user_password + "bad",
        },
        allow_redirects=True,
    )
    assert r.status_code == 401


def test_login_wrong_email(db: SessionTesting, client: TestClient) -> None:
    matches = db.query(User).filter(User.email == user["email"] + "bad").first()
    assert matches is None

    r = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": user["email"] + "bad",
            "password": user_password,
        },
        allow_redirects=True,
    )
    assert r.status_code == 401


def test_refresh(db: SessionTesting, client: TestClient) -> None:
    r1 = client.post(
        f"{settings.API_V1_STR}/auth/login/",
        data={
            "username": user["email"],
            "password": user_password,
        },
        allow_redirects=True,
    )
    assert r1.status_code == 200
    assert r1.cookies["refresh"] is not None

    r2 = client.post(
        f"{settings.API_V1_STR}/auth/refresh/",
        allow_redirects=True,
        cookies={"refresh": r1.cookies["refresh"]},
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
    matches = db.query(User).filter(User.email == inactiveUser["email"]).first()
    assert matches is not None
    assert not matches.active

    token = _create_email_verification_token(matches.id)

    r = client.get(
        f"{settings.API_V1_STR}/auth/verify/?token={token}",
        allow_redirects=True,
    )
    assert r.status_code == 200

    matches = db.query(User).get(matches.id)
    assert matches is not None
    assert matches.active
