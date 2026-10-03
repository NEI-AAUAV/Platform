"""Event endpoints: access rules, CRUD contract and user import rules."""
from datetime import datetime, timedelta
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

from app import crud
from app.core.config import settings
from app.models.event import Event
from app.schemas.user import ScopeEnum
from app.schemas.user.user import UserCreate
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting

URL = f"{settings.API_V1_STR}/event"
MANAGER = [auth_data(scopes=[ScopeEnum.MANAGER_NEI])]
START = datetime(2030, 1, 1, 10)
PAYLOAD = {
    "name": "Workshop",
    "start": START.isoformat(),
    "end": (START + timedelta(hours=2)).isoformat(),
}


@pytest.fixture
def event(db: SessionTesting) -> Event:
    e = Event(name="Existing", start=START, end=START + timedelta(hours=1))
    db.add(e)
    db.flush()
    return e


@pytest.fixture
def magic_link(monkeypatch: pytest.MonkeyPatch) -> MagicMock:
    mock = MagicMock()
    monkeypatch.setattr("app.api.api_v1.event.send_magic_link", mock)
    return mock


def _person(email: str, name: str = "Ana") -> dict:
    return {"name": name, "surname": "Silva", "email": email}


# --- reads are public ---------------------------------------------------------


def test_get_event_by_id_is_public(client: TestClient, event: Event) -> None:
    r = client.get(f"{URL}/{event.id}")

    assert r.status_code == 200
    assert r.json()["name"] == "Existing" and r.json()["id"] == event.id


def test_get_missing_event_is_404(client: TestClient) -> None:
    assert client.get(f"{URL}/999999").status_code == 404


# --- writes need manager-nei --------------------------------------------------


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (auth_data(), 403), (auth_data(scopes=[ScopeEnum.MANAGER_NEI]), 201)],
    indirect=["client"],
)
def test_create_event_access(client: TestClient, status_code: int) -> None:
    assert client.post(f"{URL}/", json=PAYLOAD).status_code == status_code


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (auth_data(), 403)],
    indirect=["client"],
)
def test_update_and_delete_and_import_are_protected(
    client: TestClient, event: Event, status_code: int
) -> None:
    assert client.put(f"{URL}/{event.id}", json={"name": "x"}).status_code == status_code
    assert client.delete(f"{URL}/{event.id}").status_code == status_code
    assert client.post(f"{URL}/{event.id}", json=[]).status_code == status_code


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_created_event_is_retrievable(client: TestClient) -> None:
    created = client.post(f"{URL}/", json=PAYLOAD).json()

    fetched = client.get(f"{URL}/{created['id']}").json()

    assert fetched["name"] == "Workshop"


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_create_event_requires_all_fields(client: TestClient) -> None:
    assert client.post(f"{URL}/", json={"name": "no dates"}).status_code == 422


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_partial_update_changes_only_sent_fields(client: TestClient, event: Event) -> None:
    r = client.put(f"{URL}/{event.id}", json={"name": "Renamed"})

    assert r.status_code == 200
    assert r.json()["name"] == "Renamed"
    assert r.json()["start"] == START.isoformat()


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_update_missing_event_is_404(client: TestClient) -> None:
    assert client.put(f"{URL}/999999", json={"name": "x"}).status_code == 404


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_deleted_event_is_gone(client: TestClient, event: Event) -> None:
    client.delete(f"{URL}/{event.id}")

    assert client.get(f"{URL}/{event.id}").status_code == 404


# --- import users -------------------------------------------------------------


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_to_missing_event_is_404(client: TestClient, magic_link) -> None:
    r = client.post(f"{URL}/999999", json=[_person("a@ua.pt")])

    assert r.status_code == 404
    magic_link.assert_not_called()


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_creates_participants_and_sends_one_magic_link_each(
    client: TestClient, db: SessionTesting, event: Event, magic_link
) -> None:
    people = [_person("a@ua.pt", "Ana"), _person("b@ua.pt", "Rui")]

    r = client.post(f"{URL}/{event.id}", json=people)

    assert r.status_code == 201 and r.json() == {"users_created": 2}
    assert magic_link.call_count == 2
    user, email = crud.user.get_by_email(db, "a@ua.pt")
    assert user.for_event == event.id
    assert user.scopes == [f"participant:{event.id}"]
    assert email.active is False  # must be confirmed through the magic link


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_reason_names_the_event(
    client: TestClient, event: Event, magic_link
) -> None:
    client.post(f"{URL}/{event.id}", json=[_person("a@ua.pt")])

    reason = magic_link.call_args.args[3]
    assert "Existing" in reason


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_does_not_duplicate_existing_users_but_grants_scope(
    client: TestClient, db: SessionTesting, event: Event, magic_link
) -> None:
    existing = crud.user.create(
        db, obj_in=UserCreate(name="Ana", surname="Silva", email="a@ua.pt"), active=True
    )

    r = client.post(f"{URL}/{event.id}", json=[_person("a@ua.pt")])

    assert r.json() == {"users_created": 0}
    magic_link.assert_not_called()
    db.expire_all()
    refreshed, _ = crud.user.get_by_email(db, "a@ua.pt")
    assert refreshed.id == existing.id
    assert f"participant:{event.id}" in refreshed.scopes


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_importing_the_same_people_twice_is_idempotent(
    client: TestClient, db: SessionTesting, event: Event, magic_link
) -> None:
    client.post(f"{URL}/{event.id}", json=[_person("a@ua.pt")])
    second = client.post(f"{URL}/{event.id}", json=[_person("a@ua.pt")])

    assert second.json() == {"users_created": 0}
    db.expire_all()
    user, _ = crud.user.get_by_email(db, "a@ua.pt")
    assert user.scopes.count(f"participant:{event.id}") == 1


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_duplicate_emails_in_one_payload_create_a_single_user(
    client: TestClient, event: Event, magic_link
) -> None:
    r = client.post(f"{URL}/{event.id}", json=[_person("a@ua.pt"), _person("a@ua.pt")])

    assert r.json() == {"users_created": 1}


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_rejects_entries_without_surname(client: TestClient, event: Event) -> None:
    r = client.post(f"{URL}/{event.id}", json=[{"name": "Ana", "email": "a@ua.pt"}])

    assert r.status_code == 422


@pytest.mark.parametrize("client", MANAGER, indirect=True)
def test_import_rejects_invalid_email(client: TestClient, event: Event) -> None:
    r = client.post(f"{URL}/{event.id}", json=[_person("not-an-email")])

    assert r.status_code == 422
