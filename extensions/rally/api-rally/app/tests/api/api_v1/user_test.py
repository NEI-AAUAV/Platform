import pytest

from fastapi.testclient import TestClient

from app.models import User
from app.core.config import settings
from app.tests.conftest import Session
from app.api.deps import get_password_hash

users = [
    {
        "username": "Test1",
        "name": "NameTest1",
        "hashed_password": get_password_hash("test"),
    },
    {
        "username": "Test2",
        "name": "NameTest2",
        "hashed_password": get_password_hash("test"),
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: Session):
    """Setup the database before each test in this module."""

    for user in users:
        db.add(User(**user))
    db.commit()


# ===========
# == LOGIN ==
# ===========


def test_login_bad_username(client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/user/token",
        data={"username": "bad", "password": "test"},
    )
    assert r.status_code == 401


def test_login_bad_password(client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/user/token",
        data={"username": "Test1", "password": "bad"},
    )
    assert r.status_code == 401


def test_login_ok(client: TestClient) -> None:
    r = client.post(
        f"{settings.API_V1_STR}/user/token",
        data={"username": "Test1", "password": "test"},
    )
    assert r.status_code == 200
    data = r.json()
    assert data["name"] == "NameTest1"
    assert data["staff_checkpoint_id"] is None
    assert data["is_admin"] is False


# ===============
# == GET USERS ==
# ===============


def test_get_users_unauthenticated(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user")
    assert r.status_code == 401


@pytest.mark.parametrize(
    "client",
    [{}, {"staff_checkpoint_id": 1}],
    indirect=["client"],
)
def test_get_users_not_admin(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user")
    assert r.status_code == 403


@pytest.mark.parametrize(
    "client",
    [{"is_admin": True}],
    indirect=["client"],
)
def test_get_users(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 2


# =================
# == UPDATE USER ==
# =================


def test_update_user_unauthenticated(client: TestClient, db: Session) -> None:
    user = db.query(User).first()
    assert user is not None
    id = user.id

    r = client.put(f"{settings.API_V1_STR}/user/{id}", json={"name": "updated"})
    assert r.status_code == 401


@pytest.mark.parametrize(
    "client",
    [{}, {"staff_checkpoint_id": 1}],
    indirect=["client"],
)
def test_update_user_not_admin(client: TestClient, db: Session) -> None:
    user = db.query(User).first()
    assert user is not None
    id = user.id

    r = client.put(f"{settings.API_V1_STR}/user/{id}", json={"name": "updated"})
    assert r.status_code == 403


@pytest.mark.parametrize(
    "client",
    [{"is_admin": True}],
    indirect=["client"],
)
def test_update_user(client: TestClient, db: Session) -> None:
    user = db.query(User).first()
    assert user is not None
    id = user.id

    r = client.put(f"{settings.API_V1_STR}/user/{id}", json={"name": "updated"})
    data = r.json()
    assert r.status_code == 200
    assert data["name"] == "updated"
