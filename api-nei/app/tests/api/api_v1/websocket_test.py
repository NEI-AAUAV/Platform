"""Websocket connection managers + endpoints (arraial and tacaua)."""

from unittest.mock import AsyncMock, MagicMock

import pytest
from fastapi.testclient import TestClient

from app.api.api_v1 import arraial_ws, tacaua_ws
from app.core.config import settings

API = settings.API_V1_STR


def _socket(*, fail_on_send: bool = False) -> MagicMock:
    ws = MagicMock()
    ws.accept = AsyncMock()
    ws.send_json = AsyncMock(side_effect=RuntimeError("closed") if fail_on_send else None)
    ws.send_text = AsyncMock()
    return ws


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture(autouse=True)
def fresh_managers(monkeypatch: pytest.MonkeyPatch):
    arraial = arraial_ws.ArraialConnectionManager()
    tacaua = tacaua_ws.ConnectionManager()
    monkeypatch.setattr(arraial_ws, "arraial_ws_manager", arraial)
    monkeypatch.setattr(tacaua_ws, "manager", tacaua)
    return arraial, tacaua


MANAGERS = [
    pytest.param(arraial_ws.ArraialConnectionManager, arraial_ws.ArraialConnectionType, id="arraial"),
    pytest.param(tacaua_ws.ConnectionManager, tacaua_ws.ConnectionType, id="tacaua"),
]


# ------------------------------------------------------------- managers


@pytest.mark.anyio
@pytest.mark.parametrize("manager_cls,kind", MANAGERS)
async def test_connect_accepts_and_tracks_socket_once(manager_cls, kind) -> None:
    manager, ws = manager_cls(), _socket()

    await manager.connect(ws)
    await manager.connect(ws)

    assert manager.active_connections[kind.GENERAL] == [ws]
    assert ws.accept.await_count == 2  # every handshake is accepted, never duplicated


@pytest.mark.anyio
@pytest.mark.parametrize("manager_cls,kind", MANAGERS)
async def test_disconnect_removes_socket_and_is_idempotent(manager_cls, kind) -> None:
    manager, ws = manager_cls(), _socket()
    await manager.connect(ws)

    manager.disconnect(ws)
    manager.disconnect(ws)  # unknown socket: no error

    assert manager.active_connections[kind.GENERAL] == []


@pytest.mark.anyio
@pytest.mark.parametrize("manager_cls,kind", MANAGERS)
async def test_broadcast_reaches_every_connected_socket(manager_cls, kind) -> None:
    manager, a, b = manager_cls(), _socket(), _socket()
    await manager.connect(a)
    await manager.connect(b)

    await manager.broadcast(kind.GENERAL, {"topic": "X"})

    a.send_json.assert_awaited_once_with({"topic": "X"})
    b.send_json.assert_awaited_once_with({"topic": "X"})


@pytest.mark.anyio
@pytest.mark.parametrize("manager_cls,kind", MANAGERS)
async def test_dead_socket_is_dropped_and_does_not_block_others(manager_cls, kind) -> None:
    manager = manager_cls()
    dead, alive = _socket(fail_on_send=True), _socket()
    await manager.connect(dead)
    await manager.connect(alive)

    await manager.broadcast(kind.GENERAL, {"n": 1})

    alive.send_json.assert_awaited_once_with({"n": 1})
    assert manager.active_connections[kind.GENERAL] == [alive]


@pytest.mark.anyio
async def test_tacaua_send_personal_message_targets_one_socket() -> None:
    manager, a, b = tacaua_ws.ConnectionManager(), _socket(), _socket()

    await manager.send_personal_message("hi", a)

    a.send_text.assert_awaited_once_with("hi")
    b.send_text.assert_not_awaited()


def test_tacaua_change_connection_type_moves_socket() -> None:
    manager, ws = tacaua_ws.ConnectionManager(), _socket()
    manager.active_connections[tacaua_ws.ConnectionType.GENERAL].append(ws)

    manager.change_connection_type(ws, tacaua_ws.ConnectionType.GENERAL)

    assert manager.active_connections[tacaua_ws.ConnectionType.GENERAL] == [ws]


def test_tacaua_change_connection_type_ignores_unknown_socket() -> None:
    manager = tacaua_ws.ConnectionManager()

    manager.change_connection_type(_socket(), tacaua_ws.ConnectionType.GENERAL)

    assert manager.active_connections[tacaua_ws.ConnectionType.GENERAL] == []


# ------------------------------------------------------------- endpoints


@pytest.fixture
def ws_app(app):
    """Expose the websocket routers (they are not part of the shared test app)."""
    from fastapi import FastAPI

    sub = FastAPI()
    sub.include_router(arraial_ws.router, prefix=API)
    sub.include_router(tacaua_ws.router, prefix=API)
    return sub


def test_arraial_socket_registers_and_unregisters_on_disconnect(ws_app, fresh_managers) -> None:
    arraial, _ = fresh_managers
    with TestClient(ws_app) as client:
        with client.websocket_connect(f"{API}/arraial/ws") as ws:
            ws.send_text("ping")  # incoming messages are ignored
            assert len(arraial.active_connections[arraial_ws.ArraialConnectionType.GENERAL]) == 1
        assert arraial.active_connections[arraial_ws.ArraialConnectionType.GENERAL] == []


def test_tacaua_live_game_message_is_broadcast_to_everyone(ws_app) -> None:
    with TestClient(ws_app) as client:
        with client.websocket_connect(f"{API}/ws") as a, client.websocket_connect(f"{API}/ws") as b:
            a.send_json({"topic": "LIVE_GAME"})

            assert a.receive_json()["topic"] == "LIVE_GAMES"
            assert b.receive_json()["game"]["team1"] == "NEI"


def test_tacaua_unknown_topic_is_ignored_and_socket_stays_usable(ws_app) -> None:
    with TestClient(ws_app) as client:
        with client.websocket_connect(f"{API}/ws") as ws:
            ws.send_json({"topic": "SOMETHING_ELSE"})
            ws.send_json({"topic": "LIVE_GAME"})

            assert ws.receive_json()["topic"] == "LIVE_GAMES"


def test_tacaua_socket_is_removed_on_disconnect(ws_app, fresh_managers) -> None:
    _, tacaua = fresh_managers
    with TestClient(ws_app) as client:
        with client.websocket_connect(f"{API}/ws"):
            assert len(tacaua.active_connections[tacaua_ws.ConnectionType.GENERAL]) == 1
        assert tacaua.active_connections[tacaua_ws.ConnectionType.GENERAL] == []


def test_http_broadcast_pushes_payload_to_connected_sockets(ws_app) -> None:
    payload = {"topic": "UPDATE_LIVE_GAME", "game": {"id": 7}}
    with TestClient(ws_app) as client:
        with client.websocket_connect(f"{API}/ws") as ws:
            r = client.post(f"{API}/ws/broadcast", json=payload)

            assert r.status_code == 200
            assert r.json() == {
                "status": "success",
                "message": "All websockets were notified.",
            }
            assert ws.receive_json() == payload


def test_http_broadcast_without_listeners_still_succeeds(ws_app) -> None:
    with TestClient(ws_app) as client:
        r = client.post(f"{API}/ws/broadcast", json={"topic": "X"})

    assert r.status_code == 200


def test_http_broadcast_rejects_non_object_body(ws_app) -> None:
    with TestClient(ws_app) as client:
        r = client.post(f"{API}/ws/broadcast", content="[1,2]", headers={"content-type": "application/json"})

    assert r.status_code == 422
