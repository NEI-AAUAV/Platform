"""Outgoing email: message envelope and SMTP delivery contract."""
from unittest.mock import AsyncMock

import pytest

from app.api import email as mail
from app.core.config import settings


pytestmark_async = pytest.mark.anyio


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture
def smtp(monkeypatch: pytest.MonkeyPatch) -> AsyncMock:
    send = AsyncMock()
    monkeypatch.setattr(mail.aiosmtplib, "send", send)
    monkeypatch.setattr(settings, "EMAIL_SENDER_ADDRESS", "nei@example.pt")
    monkeypatch.setattr(settings, "EMAIL_SMTP_HOST", "smtp.example.pt")
    monkeypatch.setattr(settings, "EMAIL_SMTP_PORT", 2525)
    monkeypatch.setattr(settings, "EMAIL_SMTP_USER", "user")
    monkeypatch.setattr(settings, "EMAIL_SMTP_PASSWORD", "pw")
    return send


def test_message_has_envelope_headers(smtp) -> None:
    msg = mail._generate_email_message("to@x.pt", "Subj", ("<b>h</b>", "plain"))

    assert msg["To"] == "to@x.pt"
    assert msg["From"] == "nei@example.pt"
    assert msg["Subject"] == "Subj"
    assert msg["Message-Id"].endswith(f"@{settings.EMAIL_DOMAIN}>")
    assert msg["Date"]


def test_message_is_multipart_with_text_before_html(smtp) -> None:
    msg = mail._generate_email_message("to@x.pt", "S", ("<b>h</b>", "plain"))

    # RFC 2046: the preferred (last) alternative must be the richest one
    types = [p.get_content_type() for p in msg.get_payload()]
    assert msg.get_content_type() == "multipart/alternative"
    assert types == ["text/plain", "text/html"]


def _assert_delivered(smtp: AsyncMock, recipient: str, subject_part: str) -> None:
    smtp.assert_awaited_once()
    message = smtp.await_args.args[0]
    kwargs = smtp.await_args.kwargs
    assert message["To"] == recipient
    assert subject_part in message["Subject"]
    assert kwargs == {
        "hostname": "smtp.example.pt",
        "port": 2525,
        "username": "user",
        "password": "pw",
    }


@pytestmark_async
async def test_send_email_confirmation(smtp) -> None:
    await mail.send_email_confirmation("a@x.pt", "Ana", "tok")

    _assert_delivered(smtp, "a@x.pt", "Confirma")
    text_part = smtp.await_args.args[0].get_payload()[0].get_payload(decode=True)
    assert b"tok" in text_part


@pytestmark_async
async def test_send_password_reset(smtp) -> None:
    await mail.send_password_reset("a@x.pt", "Ana", "tok")

    _assert_delivered(smtp, "a@x.pt", "Recupera")


@pytestmark_async
async def test_send_password_changed(smtp) -> None:
    await mail.send_password_changed("a@x.pt", "Ana")

    _assert_delivered(smtp, "a@x.pt", "alterada")


@pytestmark_async
async def test_send_magic_link(smtp) -> None:
    await mail.send_magic_link("a@x.pt", "Ana", "porque sim", "tok")

    _assert_delivered(smtp, "a@x.pt", "Ativa")


@pytestmark_async
async def test_smtp_failure_propagates_to_caller(smtp) -> None:
    smtp.side_effect = ConnectionRefusedError("smtp down")

    with pytest.raises(ConnectionRefusedError):
        await mail.send_password_changed("a@x.pt", "Ana")
