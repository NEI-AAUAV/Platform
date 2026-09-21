"""Settings must refuse to boot with an insecure or half-configured setup."""
import pytest
from pydantic import ValidationError

from app.core.config import Settings


def _settings(**overrides) -> Settings:
    return Settings(_env_file=None, **overrides)


def test_defaults_are_valid_for_development() -> None:
    assert _settings().OIDC_VERIFY_SSL is True


def test_production_rejects_disabled_tls_verification() -> None:
    with pytest.raises(ValidationError, match="OIDC_VERIFY_SSL"):
        _settings(PRODUCTION=True, OIDC_VERIFY_SSL=False)


def test_development_may_disable_tls_verification() -> None:
    assert _settings(OIDC_VERIFY_SSL=False).OIDC_VERIFY_SSL is False


def test_oidc_requires_client_credentials_in_production() -> None:
    with pytest.raises(ValidationError, match="OIDC_CLIENT_SECRET"):
        _settings(PRODUCTION=True, OIDC_ENABLED=True, OIDC_CLIENT_ID="id")


def test_oidc_with_credentials_is_valid_in_production() -> None:
    cfg = _settings(
        PRODUCTION=True,
        OIDC_ENABLED=True,
        OIDC_CLIENT_ID="id",
        OIDC_CLIENT_SECRET="secret",
    )
    assert cfg.OIDC_ENABLED is True


def test_email_requires_smtp_host_and_sender() -> None:
    with pytest.raises(ValidationError, match="EMAIL_SMTP_HOST"):
        _settings(EMAIL_ENABLED=True)


def test_recaptcha_requires_secret_key() -> None:
    with pytest.raises(ValidationError, match="RECAPTCHA_SECRET_KEY"):
        _settings(RECAPTCHA_ENABLED=True)
