"""Email templates: the link the user clicks must be built correctly."""
import pytest

from app import templating as t
from app.core.config import settings


def test_registration_links_to_verify_endpoint_with_token() -> None:
    html, text = t.render_email_registration_templates("a@b.pt", "Ana", "tok123")

    link = f"{settings.HOST}{settings.EMAIL_ACCOUNT_VERIFY_ENDPOINT}"
    assert link in html and "tok123" in html
    assert link in text and "tok123" in text
    assert "Ana" in html and "Ana" in text


def test_password_reset_links_to_reset_endpoint_with_token() -> None:
    html, text = t.render_password_reset_templates("a@b.pt", "Ana", "tok456")

    link = f"{settings.HOST}{settings.PASSWORD_RESET_ENDPOINT}"
    assert link in html and "tok456" in html
    assert link in text and "tok456" in text


def test_magic_link_includes_reason_and_magic_endpoint() -> None:
    html, text = t.render_magic_link_templates(
        "a@b.pt", "Ana", "Foste inscrito no evento X", "tok789"
    )

    link = f"{settings.HOST}{settings.MAGIC_LINK_ENDPOINT}"
    for body in (html, text):
        assert link in body and "tok789" in body
        assert "Foste inscrito no evento X" in body


def test_password_changed_greets_user_and_carries_no_token() -> None:
    html, text = t.render_password_changed_templates("a@b.pt", "Ana")

    assert "Ana" in html and "Ana" in text
    assert "token=" not in html and "token=" not in text


@pytest.mark.parametrize(
    "render",
    [
        lambda n: t.render_email_registration_templates("a@b.pt", n, "x"),
        lambda n: t.render_password_reset_templates("a@b.pt", n, "x"),
        lambda n: t.render_password_changed_templates("a@b.pt", n),
        lambda n: t.render_magic_link_templates("a@b.pt", n, "r", "x"),
    ],
)
def test_html_body_escapes_user_supplied_name(render) -> None:
    html, _ = render("<script>alert(1)</script>")

    assert "<script>alert(1)</script>" not in html
    assert "&lt;script&gt;" in html
