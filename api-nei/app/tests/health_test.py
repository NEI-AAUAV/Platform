"""Liveness vs readiness probes used by the orchestrator."""
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

import app.main as main


@pytest.fixture
def probe() -> TestClient:
    # No `with`: skip the lifespan (it would start Authentik and touch the DB)
    return TestClient(main.app)


def test_live_does_not_depend_on_the_database(
    probe: TestClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(main, "engine", MagicMock(connect=MagicMock(side_effect=RuntimeError)))

    r = probe.get("/health/live")

    assert r.status_code == 200 and r.json() == {"status": "ok"}


def test_ready_is_ok_when_database_answers(
    probe: TestClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    engine = MagicMock()
    monkeypatch.setattr(main, "engine", engine)

    r = probe.get("/health/ready")

    assert r.status_code == 200 and r.json() == {"status": "ok"}
    engine.connect.assert_called_once()


def test_ready_is_503_without_leaking_the_error_when_database_is_down(
    probe: TestClient, monkeypatch: pytest.MonkeyPatch
) -> None:
    engine = MagicMock(connect=MagicMock(side_effect=RuntimeError("password=hunter2")))
    monkeypatch.setattr(main, "engine", engine)

    r = probe.get("/health/ready")

    assert r.status_code == 503
    assert r.json() == {"detail": "Database unavailable"}
    assert "hunter2" not in r.text


def test_probes_are_hidden_from_the_openapi_schema() -> None:
    paths = main.app.openapi()["paths"]

    assert "/health/live" not in paths and "/health/ready" not in paths
