"""Characterisation tests for the Arraial scoreboard.

The module keeps its state in process memory, so every test starts from a
clean slate (see `_clean_state`).
"""
from datetime import datetime, timedelta, timezone
from typing import Any, Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.api.api_v1 import arraial
from app.core.config import settings
from app.schemas.user.user import ScopeEnum

from ._utils import auth_data

BASE = f"{settings.API_V1_STR}/arraial"

MANAGER = auth_data(sub=7, scopes=[ScopeEnum.MANAGER_ARRAIAL])
ADMIN = auth_data(sub=1, scopes=[ScopeEnum.ADMIN])
NOBODY = auth_data(sub=9)

as_manager = pytest.mark.parametrize("client", [MANAGER], indirect=True)
as_admin = pytest.mark.parametrize("client", [ADMIN], indirect=True)


def _reset_state() -> None:
    for p in arraial._arraial_points:
        p["value"] = 0
    for k in arraial._boost_ends:
        arraial._boost_ends[k] = None
    for k in arraial._boost_fractional_remainders:
        arraial._boost_fractional_remainders[k] = 0.0
    arraial._rate_limit_buckets.clear()
    arraial._arraial_log.clear()
    arraial._next_log_id = 1


@pytest.fixture(autouse=True)
def _clean_state() -> Generator[None, Any, None]:
    _reset_state()
    yield
    _reset_state()


@pytest.fixture
def boosts_on(db: Session) -> None:
    arraial._set_flag(db, arraial.CONFIG_FLAG_KEYS["boosts_enabled"], True)


def _add(client: TestClient, nucleo: str, amount: int):
    return client.put(f"{BASE}/points", json={"nucleo": nucleo, "pointIncrement": amount})


def _points(client: TestClient) -> dict[str, int]:
    return {p["nucleo"]: p["value"] for p in client.get(f"{BASE}/points").json()}


# --- config -----------------------------------------------------------------


@pytest.mark.parametrize("client", [None], indirect=True)
def test_config_defaults_to_disabled_and_unpaused(client: TestClient) -> None:
    r = client.get(f"{BASE}/config")

    assert r.status_code == 200
    body = r.json()
    assert body["enabled"] is False
    assert body["paused"] is False
    assert body["boosts_enabled"] is False
    assert body["milestones_enabled"] is False
    assert set(body["boosts"]) == set(arraial.VALID_NUCLEOS)
    assert all(v is None for v in body["boosts"].values())


@as_admin
def test_admin_config_update_is_persisted(client: TestClient) -> None:
    r = client.put(f"{BASE}/config", json={"enabled": True, "paused": True})

    assert r.status_code == 200
    cfg = client.get(f"{BASE}/config").json()
    assert cfg["enabled"] is True
    assert cfg["paused"] is True


@as_admin
def test_admin_can_enable_boosts_and_milestones(client: TestClient) -> None:
    r = client.put(
        f"{BASE}/config", json={"boosts_enabled": True, "milestones_enabled": True}
    )

    assert r.status_code == 200
    cfg = client.get(f"{BASE}/config").json()
    assert cfg["boosts_enabled"] is True
    assert cfg["milestones_enabled"] is True


@as_admin
def test_config_update_only_changes_the_fields_sent(client: TestClient) -> None:
    client.put(f"{BASE}/config", json={"boosts_enabled": True, "milestones_enabled": True})

    r = client.put(f"{BASE}/config", json={"enabled": True, "paused": False})

    assert r.json() == {
        "enabled": True,
        "paused": False,
        "boosts_enabled": True,
        "milestones_enabled": True,
        "boosts": {n: None for n in arraial.VALID_NUCLEOS},
    }


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (NOBODY, 403), (MANAGER, 403)],
    indirect=["client"],
)
def test_only_admin_can_change_config(client: TestClient, status_code: int) -> None:
    r = client.put(f"{BASE}/config", json={"enabled": True, "paused": False})

    assert r.status_code == status_code


# --- points -----------------------------------------------------------------


@pytest.mark.parametrize("client", [None], indirect=True)
def test_points_are_public_and_start_at_zero(client: TestClient) -> None:
    assert _points(client) == {"NEEETA": 0, "NEECT": 0, "NEI": 0}


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (NOBODY, 403)],
    indirect=["client"],
)
def test_updating_points_requires_manager(client: TestClient, status_code: int) -> None:
    assert _add(client, "NEI", 1).status_code == status_code


@as_manager
def test_points_accumulate_per_nucleo(client: TestClient) -> None:
    _add(client, "NEI", 5)
    _add(client, "NEI", 3)
    _add(client, "NEECT", 2)

    assert _points(client) == {"NEEETA": 0, "NEECT": 2, "NEI": 8}


@as_manager
@pytest.mark.parametrize(
    "payload",
    [
        {"nucleo": "NOPE", "pointIncrement": 1},
        {"nucleo": "NEI", "pointIncrement": 1001},
        {"nucleo": "NEI", "pointIncrement": -1001},
    ],
)
def test_invalid_updates_are_rejected(client: TestClient, payload: dict) -> None:
    assert client.put(f"{BASE}/points", json=payload).status_code == 422


@as_manager
def test_points_cannot_go_below_zero(client: TestClient) -> None:
    _add(client, "NEI", 2)

    r = _add(client, "NEI", -3)

    assert r.status_code == 400
    assert _points(client)["NEI"] == 2


@as_admin
def test_updates_are_refused_while_paused(client: TestClient) -> None:
    client.put(f"{BASE}/config", json={"enabled": True, "paused": True})

    assert _add(client, "NEI", 1).status_code == 423
    assert _points(client)["NEI"] == 0


@as_manager
def test_rate_limit_returns_429_after_burst(
    client: TestClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(arraial, "TOKEN_BUCKET_BURST", 2)
    monkeypatch.setattr(arraial, "TOKEN_BUCKET_RATE_PER_MINUTE", 0)

    codes = [_add(client, "NEI", 1).status_code for _ in range(3)]

    assert codes == [200, 200, 429]


# --- boost ------------------------------------------------------------------


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_boost_multiplies_positive_increments_and_carries_the_remainder(
    client: TestClient,
) -> None:
    assert client.post(f"{BASE}/boost/NEI").status_code == 200

    _add(client, "NEI", 10)  # 12.5 -> 12, carry .5
    _add(client, "NEI", 10)  # 12.5 + .5 -> 13

    assert _points(client)["NEI"] == 25


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_boost_does_not_affect_negative_increments(client: TestClient) -> None:
    _add(client, "NEI", 10)
    client.post(f"{BASE}/boost/NEI")

    _add(client, "NEI", -4)

    assert _points(client)["NEI"] == 6


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_boost_only_applies_to_its_own_nucleo(client: TestClient) -> None:
    client.post(f"{BASE}/boost/NEI")

    _add(client, "NEECT", 10)

    assert _points(client)["NEECT"] == 10


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_activating_a_boost_twice_extends_it(client: TestClient) -> None:
    client.post(f"{BASE}/boost/NEI")
    first = arraial._boost_ends["NEI"]

    client.post(f"{BASE}/boost/NEI")

    assert arraial._boost_ends["NEI"] - first == timedelta(
        minutes=arraial.BOOST_DURATION_MINUTES
    )


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_boost_rejects_unknown_nucleo(client: TestClient) -> None:
    assert client.post(f"{BASE}/boost/NOPE").status_code == 400


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_expired_boost_no_longer_applies(client: TestClient) -> None:
    arraial._boost_ends["NEI"] = datetime.now(timezone.utc) - timedelta(seconds=1)

    _add(client, "NEI", 10)

    assert _points(client)["NEI"] == 10


@as_manager
def test_boost_is_refused_while_boosts_are_disabled(client: TestClient) -> None:
    r = client.post(f"{BASE}/boost/NEI")

    assert r.status_code == 409
    assert arraial._boost_ends["NEI"] is None


@as_manager
def test_running_boost_is_ignored_while_boosts_are_disabled(client: TestClient) -> None:
    arraial._boost_ends["NEI"] = datetime.now(timezone.utc) + timedelta(minutes=5)

    _add(client, "NEI", 10)

    assert _points(client)["NEI"] == 10


@as_admin
@pytest.mark.usefixtures("boosts_on")
def test_disabling_boosts_cancels_running_boosts(client: TestClient) -> None:
    client.post(f"{BASE}/boost/NEI")

    r = client.put(f"{BASE}/config", json={"boosts_enabled": False})

    assert r.json()["boosts"]["NEI"] is None
    assert arraial._boost_ends["NEI"] is None


# --- log & rollback ---------------------------------------------------------


@as_manager
def test_log_lists_changes_newest_first_with_the_acting_user(
    client: TestClient,
) -> None:
    _add(client, "NEI", 1)
    _add(client, "NEECT", 2)

    items = client.get(f"{BASE}/log").json()["items"]

    assert [e["nucleo"] for e in items] == ["NEECT", "NEI"]
    assert items[0]["user_id"] == 7
    assert items[0]["delta"] == 2
    assert items[0]["new_value"] == 2


@as_manager
def test_log_paginates_and_filters(client: TestClient) -> None:
    for _ in range(3):
        _add(client, "NEI", 1)
    _add(client, "NEECT", 1)

    page = client.get(f"{BASE}/log", params={"limit": 2}).json()
    only_nei = client.get(f"{BASE}/log", params={"nucleo": "NEI"}).json()

    assert len(page["items"]) == 2
    assert page["next_offset"] == 2
    assert len(only_nei["items"]) == 3
    assert only_nei["next_offset"] is None


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (NOBODY, 403)],
    indirect=["client"],
)
def test_log_requires_manager(client: TestClient, status_code: int) -> None:
    assert client.get(f"{BASE}/log").status_code == status_code


@as_manager
def test_rollback_reverts_the_change_and_marks_the_entry(client: TestClient) -> None:
    _add(client, "NEI", 5)
    entry_id = client.get(f"{BASE}/log").json()["items"][0]["id"]

    r = client.post(f"{BASE}/rollback/{entry_id}")

    assert r.status_code == 200
    assert _points(client)["NEI"] == 0
    assert client.get(f"{BASE}/log").json()["items"][0]["rolled_back"] is True


@as_manager
def test_rollback_is_idempotent(client: TestClient) -> None:
    _add(client, "NEI", 5)
    entry_id = client.get(f"{BASE}/log").json()["items"][0]["id"]

    client.post(f"{BASE}/rollback/{entry_id}")
    client.post(f"{BASE}/rollback/{entry_id}")

    assert _points(client)["NEI"] == 0


@as_manager
def test_rollback_never_goes_below_zero(client: TestClient) -> None:
    _add(client, "NEI", 5)
    entry_id = client.get(f"{BASE}/log").json()["items"][0]["id"]
    _add(client, "NEI", -5)

    client.post(f"{BASE}/rollback/{entry_id}")

    assert _points(client)["NEI"] == 0


@as_manager
def test_rollback_of_unknown_entry_is_404(client: TestClient) -> None:
    assert client.post(f"{BASE}/rollback/999").status_code == 404


@as_manager
@pytest.mark.usefixtures("boosts_on")
def test_rollback_of_a_boost_cancels_it(client: TestClient) -> None:
    client.post(f"{BASE}/boost/NEI")
    entry_id = client.get(f"{BASE}/log").json()["items"][0]["id"]

    client.post(f"{BASE}/rollback/{entry_id}")

    assert arraial._boost_ends["NEI"] is None


# --- reset ------------------------------------------------------------------


@pytest.mark.parametrize(
    "client,status_code",
    [(None, 401), (NOBODY, 403), (MANAGER, 403)],
    indirect=["client"],
)
def test_only_admin_can_reset(client: TestClient, status_code: int) -> None:
    assert client.post(f"{BASE}/reset").status_code == status_code


@as_admin
@pytest.mark.usefixtures("boosts_on")
def test_reset_clears_points_boosts_and_log(client: TestClient) -> None:
    _add(client, "NEI", 5)
    client.post(f"{BASE}/boost/NEI")

    assert client.post(f"{BASE}/reset").status_code == 200

    assert _points(client) == {"NEEETA": 0, "NEECT": 0, "NEI": 0}
    assert all(v is None for v in arraial._get_boosts_response().values())
    assert arraial._arraial_log == []
