"""reCAPTCHA verification: disabled bypass, success score, rejection."""

from unittest.mock import AsyncMock, MagicMock

import pytest
from fastapi import HTTPException

from app.api import recaptcha
from app.core.config import settings


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture
def google(monkeypatch: pytest.MonkeyPatch) -> MagicMock:
    """Patch `httpx.AsyncClient` so no network call is ever made."""
    client = MagicMock()
    client.post = AsyncMock()
    ctx = MagicMock()
    ctx.__aenter__ = AsyncMock(return_value=client)
    ctx.__aexit__ = AsyncMock(return_value=False)
    monkeypatch.setattr(recaptcha.httpx, "AsyncClient", MagicMock(return_value=ctx))
    return client


def _response(payload: dict) -> MagicMock:
    res = MagicMock()
    res.json.return_value = payload
    return res


@pytest.mark.anyio
async def test_disabled_returns_perfect_score_without_network(
    monkeypatch, google
) -> None:
    monkeypatch.setattr(settings, "RECAPTCHA_ENABLED", False)

    assert await recaptcha.verify_recaptcha(None) == 1.0
    google.post.assert_not_awaited()


@pytest.mark.anyio
async def test_enabled_returns_score_and_posts_secret_and_token(
    monkeypatch, google
) -> None:
    monkeypatch.setattr(settings, "RECAPTCHA_ENABLED", True)
    monkeypatch.setattr(settings, "RECAPTCHA_SECRET_KEY", "shh")
    google.post.return_value = _response({"success": True, "score": 0.9})

    score = await recaptcha.verify_recaptcha("user-token")

    assert score == 0.9
    google.post.assert_awaited_once_with(
        settings.RECAPTCHA_VERIFY_URL,
        data={"secret": "shh", "response": "user-token"},
    )


@pytest.mark.anyio
async def test_enabled_rejects_unsuccessful_verification(monkeypatch, google) -> None:
    monkeypatch.setattr(settings, "RECAPTCHA_ENABLED", True)
    monkeypatch.setattr(settings, "RECAPTCHA_SECRET_KEY", "shh")
    google.post.return_value = _response({"success": False})

    with pytest.raises(HTTPException) as exc:
        await recaptcha.verify_recaptcha("bad")

    assert exc.value.status_code == 400
    assert exc.value.detail == "Invalid recaptcha token"
    assert exc.value.headers == {"WWW-Authenticate": "reCaptcha"}


@pytest.mark.anyio
async def test_enabled_with_missing_token_is_still_sent_and_rejected(
    monkeypatch, google
) -> None:
    monkeypatch.setattr(settings, "RECAPTCHA_ENABLED", True)
    monkeypatch.setattr(settings, "RECAPTCHA_SECRET_KEY", "shh")
    google.post.return_value = _response({"success": False})

    with pytest.raises(HTTPException):
        await recaptcha.verify_recaptcha(None)
