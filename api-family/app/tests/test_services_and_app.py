"""Storage client, exception helpers, logging setup and app wiring."""

import logging
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient
from loguru import logger

from app import exception
from app.core import logging as app_logging
from app.core.config import settings
from app.services import storage as storage_mod


# ---------------------------------------------------------------------- storage


def _configure(monkeypatch, **overrides) -> None:
    values = {
        "R2_ENDPOINT_URL": "https://r2.test",
        "R2_ACCESS_KEY_ID": "id",
        "R2_SECRET_ACCESS_KEY": "secret",
        "R2_BUCKET": "bucket",
        "R2_PUBLIC_BASE_URL": "https://cdn.test/",
        **overrides,
    }
    for name, value in values.items():
        monkeypatch.setattr(settings, name, value)


@pytest.fixture
def s3(monkeypatch) -> MagicMock:
    client = MagicMock()
    monkeypatch.setattr(storage_mod.boto3, "client", MagicMock(return_value=client))
    return client


def test_storage_is_disabled_unless_every_setting_is_present(monkeypatch) -> None:
    for missing in (
        "R2_ENDPOINT_URL", "R2_ACCESS_KEY_ID", "R2_SECRET_ACCESS_KEY",
        "R2_BUCKET", "R2_PUBLIC_BASE_URL",
    ):
        _configure(monkeypatch, **{missing: None})

        client = storage_mod.StorageClient()

        assert client.enabled is False and client.client is None, missing


def test_disabled_storage_never_uploads_or_fails_on_delete(monkeypatch) -> None:
    _configure(monkeypatch, R2_BUCKET=None)
    client = storage_mod.StorageClient()

    assert client.upload_image("k", b"x", "image/jpeg") is None
    assert client.delete_image("https://cdn.test/k") is True


def test_upload_puts_public_object_and_returns_public_url(monkeypatch, s3) -> None:
    _configure(monkeypatch)
    client = storage_mod.StorageClient()

    url = client.upload_image("family/users/1/a.jpg", b"data", "image/jpeg")

    assert url == "https://cdn.test/family/users/1/a.jpg"  # no double slash
    s3.put_object.assert_called_once_with(
        Bucket="bucket", Key="family/users/1/a.jpg", Body=b"data",
        ContentType="image/jpeg", ACL="public-read",
    )


def test_upload_failure_returns_none(monkeypatch, s3) -> None:
    _configure(monkeypatch)
    s3.put_object.side_effect = RuntimeError("boom")

    assert storage_mod.StorageClient().upload_image("k", b"x", "image/jpeg") is None


def test_delete_extracts_the_key_from_the_public_url(monkeypatch, s3) -> None:
    _configure(monkeypatch)

    ok = storage_mod.StorageClient().delete_image("https://cdn.test/family/users/1/a.jpg")

    assert ok is True
    s3.delete_object.assert_called_once_with(Bucket="bucket", Key="family/users/1/a.jpg")


@pytest.mark.parametrize("url", [None, "", "/static/local.jpg", "https://other.test/a.jpg"])
def test_delete_ignores_empty_and_foreign_urls(monkeypatch, s3, url) -> None:
    _configure(monkeypatch)

    assert storage_mod.StorageClient().delete_image(url) is True
    s3.delete_object.assert_not_called()


def test_delete_failure_is_reported_as_false(monkeypatch, s3) -> None:
    _configure(monkeypatch)
    s3.delete_object.side_effect = RuntimeError("boom")

    assert storage_mod.StorageClient().delete_image("https://cdn.test/a.jpg") is False


# -------------------------------------------------------------------- exceptions


def test_api_exception_defaults_to_class_attributes() -> None:
    exc = exception.NotFoundException()

    assert (exc.status_code, exc.detail) == (404, "Result Not Found")


def test_api_exception_allows_overrides() -> None:
    exc = exception.NotFoundException(detail="Gone", headers={"X": "1"})

    assert exc.detail == "Gone" and exc.headers == {"X": "1"}
    assert exc.status_code == 404


def test_base_api_exception_is_a_400() -> None:
    assert exception.APIException(detail="bad").status_code == 400


# ----------------------------------------------------------------------- logging


@pytest.fixture
def loguru_records():
    records: list = []
    sink = logger.add(lambda m: records.append(m.record), level=0)
    yield records
    logger.remove(sink)


def test_format_record_adds_payload_section_only_when_present() -> None:
    plain = app_logging.format_record({"extra": {}})
    record = {"extra": {"payload": {"a": 1}}}
    with_payload = app_logging.format_record(record)

    assert "extra[payload]" not in plain
    assert "extra[payload]" in with_payload and "'a': 1" in record["extra"]["payload"]


def test_stdlib_records_are_forwarded_to_loguru(loguru_records) -> None:
    app_logging.InterceptHandler().emit(
        logging.LogRecord("lib", logging.ERROR, __file__, 1, "bad %s", ("thing",), None)
    )

    assert [(r["level"].name, r["message"]) for r in loguru_records] == [("ERROR", "bad thing")]


def test_init_logging_replaces_uvicorn_handlers_with_the_loguru_bridge(monkeypatch) -> None:
    configure = MagicMock()
    monkeypatch.setattr(app_logging.logger, "configure", configure)
    uvicorn = logging.getLogger("uvicorn")
    child = logging.getLogger("uvicorn.error")
    saved = (uvicorn.handlers, child.handlers)
    child.handlers = [logging.NullHandler()]
    try:
        app_logging.init_logging()

        assert child.handlers == []
        assert [type(h) for h in uvicorn.handlers] == [app_logging.InterceptHandler]
    finally:
        uvicorn.handlers, child.handlers = saved
    configure.assert_called_once()
    assert configure.call_args.kwargs["handlers"][0]["format"] is app_logging.format_record


# -------------------------------------------------------------------------- main


def test_application_exposes_the_v1_api_and_cors() -> None:
    from app.main import app

    paths = app.openapi()["paths"]

    assert f"{settings.API_V1_STR}/course/" in paths
    assert any(m.cls.__name__ == "CORSMiddleware" for m in app.user_middleware)


def test_lifespan_initialises_logging(monkeypatch) -> None:
    import app.main as main

    init = MagicMock()
    monkeypatch.setattr(main, "init_logging", init)

    with TestClient(main.app):
        pass

    init.assert_called_once()


def test_cors_preflight_allows_configured_origin() -> None:
    from app.main import app

    origin = settings.BACKEND_CORS_ORIGINS[0]
    with TestClient(app) as client:
        r = client.options(
            f"{settings.API_V1_STR}/course/",
            headers={"Origin": origin, "Access-Control-Request-Method": "GET"},
        )

    assert r.headers["access-control-allow-origin"] == origin
    assert r.headers["access-control-allow-credentials"] == "true"


def test_cors_preflight_rejects_unknown_origin() -> None:
    from app.main import app

    with TestClient(app) as client:
        r = client.options(
            f"{settings.API_V1_STR}/course/",
            headers={"Origin": "https://evil.example", "Access-Control-Request-Method": "GET"},
        )

    assert "access-control-allow-origin" not in r.headers
