"""User endpoints beyond the basic CRUD: /me, field-level permissions, listings."""
import json

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from app import crud
from app.api.api_v1.user import check_update_fields, user_listing_type
from app.core.config import settings
from app.schemas.user import ScopeEnum, UserUpdate
from app.schemas.user.user import (
    AdminUserListing,
    AnonymousUserListing,
    ManagerUserListing,
    UserCreate,
    UserListing,
)
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting

URL = f"{settings.API_V1_STR}/user"


def _make(db: SessionTesting, name: str, surname: str, email: str, active=True):
    return crud.user.create(
        db, obj_in=UserCreate(name=name, surname=surname, email=email), active=active
    )


# --- which listing a caller is allowed to see ------------------------------


@pytest.mark.parametrize(
    "scopes, expected",
    [
        (None, AnonymousUserListing),
        (set(), UserListing),
        ({ScopeEnum.MANAGER_GALA}, UserListing),
        ({ScopeEnum.MANAGER_NEI}, ManagerUserListing),
        ({ScopeEnum.ADMIN}, AdminUserListing),
        # admin wins regardless of what else the token carries
        ({ScopeEnum.MANAGER_NEI, ScopeEnum.ADMIN}, AdminUserListing),
    ],
)
def test_user_listing_type_by_scope(scopes, expected) -> None:
    assert user_listing_type(scopes) is expected


# --- who may change which fields -------------------------------------------


def _update(**fields) -> UserUpdate:
    return UserUpdate(**fields)


@pytest.mark.parametrize(
    "fields, scopes, allowed",
    [
        ({"name": "x"}, set(), True),
        ({"nmec": 1}, set(), False),
        ({"nmec": 1}, {ScopeEnum.MANAGER_NEI}, True),
        ({"nmec": 1}, {ScopeEnum.ADMIN}, True),
        ({"iupi": "abc"}, {ScopeEnum.MANAGER_NEI}, False),
        ({"scopes": ["admin"]}, {ScopeEnum.MANAGER_NEI}, False),
        ({"iupi": "abc"}, {ScopeEnum.ADMIN}, True),
        ({"scopes": ["admin"]}, {ScopeEnum.ADMIN}, True),
        ({"scopes": ["admin"]}, {ScopeEnum.MANAGER_NEI, ScopeEnum.ADMIN}, True),
    ],
)
def test_check_update_fields(fields, scopes, allowed) -> None:
    form = _update(**fields)

    if allowed:
        check_update_fields(form, scopes)
    else:
        with pytest.raises(HTTPException) as exc:
            check_update_fields(form, scopes)
        assert exc.value.status_code == 403


def test_privileged_fields_only_count_when_actually_sent() -> None:
    # A form that merely *could* carry nmec must not require a manager
    check_update_fields(_update(name="x"), set())


def _form(**fields) -> dict:
    """`PUT /me` takes the update schema stringified in a `user` form field."""
    return {"user": json.dumps(fields)}


# --- GET /user/ -------------------------------------------------------------


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.MANAGER_NEI])], indirect=True
)
def test_listing_is_sorted_by_name_then_surname_ignoring_case(
    client: TestClient, db: SessionTesting
) -> None:
    _make(db, "rui", "Zé", "r@ua.pt")
    _make(db, "Ana", "Silva", "a1@ua.pt")
    _make(db, "ana", "Costa", "a2@ua.pt")

    data = client.get(f"{URL}/").json()

    assert [(u["name"], u["surname"]) for u in data] == [
        ("ana", "Costa"),
        ("Ana", "Silva"),
        ("rui", "Zé"),
    ]


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.MANAGER_NEI])], indirect=True
)
def test_listing_exposes_only_active_emails(
    client: TestClient, db: SessionTesting
) -> None:
    _make(db, "Act", "A", "act@ua.pt", active=True)
    _make(db, "Pen", "P", "pen@ua.pt", active=False)

    by_name = {u["name"]: u for u in client.get(f"{URL}/").json()}

    assert by_name["Act"]["email"] == "act@ua.pt"
    assert by_name["Pen"]["email"] is None


# --- /user/me ---------------------------------------------------------------


def test_me_requires_authentication(client: TestClient) -> None:
    assert client.get(f"{URL}/me").status_code == 401


def test_me_returns_the_authenticated_user(
    app, db: SessionTesting, client: TestClient
) -> None:
    from app.api.api_v1.auth import get_auth_data

    me = _make(db, "Ana", "Silva", "ana@ua.pt")
    app.dependency_overrides[get_auth_data] = lambda: auth_data(sub=me.id)

    r = client.get(f"{URL}/me")

    assert r.status_code == 200 and r.json()["id"] == me.id


@pytest.mark.parametrize("client", [auth_data(sub=424242)], indirect=True)
def test_me_for_deleted_user_is_404(client: TestClient) -> None:
    assert client.get(f"{URL}/me").status_code == 404


def test_update_me_changes_own_profile(app, db: SessionTesting, client: TestClient) -> None:
    from app.api.api_v1.auth import get_auth_data

    me = _make(db, "Ana", "Silva", "ana@ua.pt")
    app.dependency_overrides[get_auth_data] = lambda: auth_data(sub=me.id)

    r = client.put(f"{URL}/me", data=_form(name="Ana Maria"))

    assert r.status_code == 200 and r.json()["name"] == "Ana Maria"
    assert r.json()["surname"] == "Silva"  # untouched fields stay


def test_update_me_cannot_set_own_scopes(app, db: SessionTesting, client: TestClient) -> None:
    from app.api.api_v1.auth import get_auth_data

    me = _make(db, "Ana", "Silva", "ana@ua.pt")
    app.dependency_overrides[get_auth_data] = lambda: auth_data(sub=me.id)

    r = client.put(f"{URL}/me", data=_form(scopes=["admin"]))

    assert r.status_code == 403


def test_update_me_cannot_set_own_nmec(app, db: SessionTesting, client: TestClient) -> None:
    from app.api.api_v1.auth import get_auth_data

    me = _make(db, "Ana", "Silva", "ana@ua.pt")
    app.dependency_overrides[get_auth_data] = lambda: auth_data(sub=me.id)

    assert client.put(f"{URL}/me", data=_form(nmec=1)).status_code == 403


@pytest.mark.parametrize("client", [auth_data(sub=424242)], indirect=True)
def test_update_me_for_missing_user_is_404(client: TestClient) -> None:
    assert client.put(f"{URL}/me", data=_form(name="x")).status_code == 404


# --- POST /user/ ------------------------------------------------------------


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.ADMIN])], indirect=True
)
def test_create_user_without_surname_is_422_not_500(client: TestClient) -> None:
    r = client.post(f"{URL}/", json={"name": "Ana", "email": "ana@ua.pt"})

    assert r.status_code == 422
