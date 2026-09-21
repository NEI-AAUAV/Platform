from datetime import datetime, timedelta

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models.event import Event
from app.schemas.user import ScopeEnum
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting


@pytest.fixture
def event_id(db: SessionTesting) -> int:
    event = Event(
        name="Atomic event",
        start=datetime.now(),
        end=datetime.now() + timedelta(hours=1),
    )
    db.add(event)
    db.flush()
    return event.id


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.MANAGER_NEI])], indirect=True
)
def test_delete_event_is_empty_204(client: TestClient, event_id: int) -> None:
    response = client.delete(f"{settings.API_V1_STR}/event/{event_id}")
    assert response.status_code == 204
    assert response.content == b""


@pytest.mark.parametrize(
    "client", [auth_data(scopes=[ScopeEnum.MANAGER_NEI])], indirect=True
)
def test_delete_missing_event_is_404(client: TestClient) -> None:
    response = client.delete(f"{settings.API_V1_STR}/event/999999")
    assert response.status_code == 404


def test_events_are_ordered_by_start_then_id(client: TestClient, db: SessionTesting) -> None:
    now = datetime.now()
    db.add_all(
        [
            Event(name="Later", start=now + timedelta(days=1), end=now + timedelta(days=2)),
            Event(name="Earlier", start=now, end=now + timedelta(hours=1)),
        ]
    )
    db.flush()
    response = client.get(f"{settings.API_V1_STR}/event/")
    assert response.status_code == 200
    assert [event["name"] for event in response.json()] == ["Earlier", "Later"]
