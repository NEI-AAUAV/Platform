import pytest

from fastapi.testclient import TestClient
from app.api.auth import ScopeEnum

from app.models import User
from app.core.config import settings
from app.models.checkpoint import CheckPoint
from app.tests.conftest import Session

users = [
    {
        "id": 0,
        "name": "NameTest1",
    },
    {"id": 1, "name": "NameTest2", "staff_checkpoint_id": 1},
]


@pytest.fixture(autouse=True)
def setup_database(db: Session):
    """Setup the database before each test in this module."""

    db.add(CheckPoint(id=1, name="Test", shot_name="Test", description="Test"))
    for user in users:
        db.add(User(**user))
    db.commit()


# ===============
# == GET USERS ==
# ===============


def test_get_users_unauthenticated(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user")
    assert r.status_code == 401


@pytest.mark.parametrize(
    "client",
    [{}, {"sub": 1}],
    indirect=["client"],
)
def test_get_users_not_admin(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/user")
    assert r.status_code == 403


@pytest.mark.parametrize(
    "client",
    [
        {"scopes": [ScopeEnum.ADMIN]},
        {"scopes": [ScopeEnum.MANAGER_RALLY]},
    ],
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
    [{}, {"sub": 1}],
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
    [
        {"scopes": [ScopeEnum.ADMIN]},
        {"scopes": [ScopeEnum.MANAGER_RALLY]},
    ],
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
