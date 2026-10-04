"""Logging setup, dynamic OAuth2 scheme, app lifespan and health probes."""

import logging
from contextlib import contextmanager
from unittest.mock import AsyncMock, MagicMock

import pytest
from fastapi import HTTPException, Request
from fastapi.testclient import TestClient
from loguru import logger

import app.main as main_mod
from app.core import dynamic_oauth as dyn
from app.core import logging as app_logging
from app.core.config import settings


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


# ------------------------------------------------------------------ logging


@pytest.fixture
def loguru_sink():
    messages: list = []
    sink_id = logger.add(lambda m: messages.append(m.record), level=0)
    yield messages
    logger.remove(sink_id)


def _record(extra: dict) -> dict:
    return {"extra": dict(extra)}


def test_format_record_without_payload_has_no_payload_section() -> None:
    fmt = app_logging.format_record(_record({}))

    assert "{extra[payload]}" not in fmt
    assert fmt.endswith("{exception}\n")


def test_format_record_with_payload_pretty_prints_it() -> None:
    record = _record({"payload": {"a": 1}})

    fmt = app_logging.format_record(record)

    assert "{extra[payload]}" in fmt
    assert "'a': 1" in record["extra"]["payload"]


def test_stdlib_log_records_are_forwarded_to_loguru(loguru_sink) -> None:
    handler = app_logging.InterceptHandler()
    record = logging.LogRecord("some.lib", logging.WARNING, __file__, 1, "hello %s", ("x",), None)

    handler.emit(record)

    assert [(r["level"].name, r["message"]) for r in loguru_sink] == [("WARNING", "hello x")]


def test_unknown_stdlib_level_is_forwarded_by_number(loguru_sink) -> None:
    handler = app_logging.InterceptHandler()
    record = logging.LogRecord("lib", 25, __file__, 1, "custom", None, None)
    record.levelname = "NOTALEVEL"

    handler.emit(record)

    assert loguru_sink[-1]["level"].no == 25


@pytest.mark.parametrize("production,level,diagnose", [(True, logging.INFO, False), (False, logging.DEBUG, True)])
def test_init_logging_picks_level_and_hides_locals_in_production(
    monkeypatch, production, level, diagnose
) -> None:
    add, remove, basic = MagicMock(), MagicMock(), MagicMock()
    monkeypatch.setattr(app_logging.logger, "add", add)
    monkeypatch.setattr(app_logging.logger, "remove", remove)
    monkeypatch.setattr(app_logging.logger, "level", MagicMock())
    monkeypatch.setattr(app_logging.logging, "basicConfig", basic)
    monkeypatch.setattr(settings, "PRODUCTION", production)

    app_logging.init_logging()

    basic.assert_called_once()
    assert basic.call_args.kwargs["force"] is True
    assert isinstance(basic.call_args.kwargs["handlers"][0], app_logging.InterceptHandler)
    kwargs = add.call_args.kwargs
    assert kwargs["level"] == level
    assert kwargs["diagnose"] is diagnose
    assert kwargs["format"] is app_logging.format_record


# ------------------------------------------------------------ dynamic oauth


@pytest.fixture
def scheme(monkeypatch) -> dyn.DynamicOAuth2PasswordBearer:
    monkeypatch.setattr(dyn, "load_extension_scopes", lambda: {"manager-gala": "Gala"})
    return dyn.DynamicOAuth2PasswordBearer(
        tokenUrl="/login", scopes={"admin": "Everything"}, auto_error=True
    )


def _request(auth: str | None) -> Request:
    headers = [(b"authorization", auth.encode())] if auth is not None else []
    return Request({"type": "http", "headers": headers})


def test_get_scopes_merges_base_and_extension_scopes(scheme) -> None:
    assert scheme.get_scopes() == {"admin": "Everything", "manager-gala": "Gala"}


def test_extension_scope_cannot_be_lost_nor_mutate_base(scheme) -> None:
    scheme.get_scopes()["injected"] = "x"

    assert "injected" not in scheme.get_scopes()


def test_update_scopes_refreshes_scheme_and_openapi_flow(scheme) -> None:
    scheme.update_scopes()

    assert scheme.scopes == {"admin": "Everything", "manager-gala": "Gala"}
    assert scheme.model.flows.password.scopes == scheme.scopes


@pytest.mark.anyio
async def test_extracts_bearer_token(scheme) -> None:
    assert await scheme(_request("Bearer abc.def")) == "abc.def"
    assert await scheme(_request("bearer lower")) == "lower"


@pytest.mark.anyio
@pytest.mark.parametrize("header", [None, "", "Basic abc", "Token abc"])
async def test_missing_or_non_bearer_credentials_are_401_when_auto_error(scheme, header) -> None:
    request = _request(header)

    with pytest.raises(HTTPException) as exc:
        await scheme(request)

    assert exc.value.status_code == 401
    assert exc.value.headers == {"WWW-Authenticate": "Bearer"}


@pytest.mark.anyio
async def test_missing_credentials_return_none_without_auto_error(monkeypatch) -> None:
    monkeypatch.setattr(dyn, "load_extension_scopes", lambda: {})
    lenient = dyn.DynamicOAuth2PasswordBearer(tokenUrl="/login", auto_error=False)

    assert await lenient(_request(None)) is None
    assert await lenient(_request("Basic x")) is None


def test_global_scheme_exposes_base_scopes() -> None:
    scopes = dyn.dynamic_oauth2_scheme.get_scopes()

    assert {"admin", "manager-nei", "manager-arraial"} <= set(scopes)
    assert dyn.dynamic_oauth2_scheme.auto_error is False


# ----------------------------------------------------------------- main app


def test_liveness_probe_does_not_touch_the_database(monkeypatch) -> None:
    boom = MagicMock(side_effect=AssertionError("db used"))
    monkeypatch.setattr(main_mod.engine, "connect", boom, raising=False)

    r = TestClient(main_mod.app).get("/health/live")

    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_readiness_probe_ok_when_database_answers(monkeypatch) -> None:
    conn = MagicMock()

    @contextmanager
    def connect():
        yield conn

    monkeypatch.setattr(main_mod, "engine", MagicMock(connect=connect))

    r = TestClient(main_mod.app).get("/health/ready")

    assert r.status_code == 200
    assert r.json() == {"status": "ok"}
    assert str(conn.execute.call_args.args[0]) == "SELECT 1"


def test_readiness_probe_is_503_without_leaking_error(monkeypatch) -> None:
    engine = MagicMock()
    engine.connect.side_effect = RuntimeError("password=hunter2 host=db")
    monkeypatch.setattr(main_mod, "engine", engine)

    r = TestClient(main_mod.app).get("/health/ready")

    assert r.status_code == 503
    assert r.json() == {"detail": "Database unavailable"}


def test_health_probes_are_not_in_openapi_schema() -> None:
    assert not any(p.startswith("/health") for p in main_mod.app.openapi()["paths"])


@pytest.mark.anyio
async def test_lifespan_initialises_on_startup_and_closes_client_on_shutdown(monkeypatch) -> None:
    order: list[str] = []
    monkeypatch.setattr(main_mod, "init_logging", lambda: order.append("logging"))
    monkeypatch.setattr(main_mod, "init_db", lambda: order.append("db"))
    monkeypatch.setattr(main_mod, "load_scopes_from_manifests", lambda: order.append("manifests"))
    monkeypatch.setattr(
        main_mod, "dynamic_oauth2_scheme", MagicMock(update_scopes=lambda: order.append("scopes"))
    )
    client = MagicMock(start=lambda: order.append("start"), close=AsyncMock(side_effect=lambda: order.append("close")))
    monkeypatch.setattr(main_mod, "authentik_client", client)

    async with main_mod.lifespan(main_mod.app):
        # manifests must be loaded before the OAuth scheme re-reads the scopes
        assert order == ["logging", "db", "manifests", "scopes", "start"]

    assert order[-1] == "close"


@pytest.mark.anyio
async def test_lifespan_closes_client_even_if_app_crashes(monkeypatch) -> None:
    for name in ("init_logging", "init_db", "load_scopes_from_manifests"):
        monkeypatch.setattr(main_mod, name, lambda: None)
    monkeypatch.setattr(main_mod, "dynamic_oauth2_scheme", MagicMock())
    client = MagicMock(start=lambda: None, close=AsyncMock())
    monkeypatch.setattr(main_mod, "authentik_client", client)

    lifespan = main_mod.lifespan(main_mod.app)
    crash = RuntimeError("crash")

    with pytest.raises(RuntimeError):
        async with lifespan:
            raise crash

    client.close.assert_awaited_once()
