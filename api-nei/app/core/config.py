import os
import pathlib

from datetime import timedelta
from pydantic import field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List, Optional


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=True
    )

    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/nei/v1"
    STATIC_STR: str = "/static/nei"

    HOST: str = "https://nei.web.ua.pt" if PRODUCTION else "http://localhost"
    STATIC_URL: str = HOST + STATIC_STR
    # Base URL for assets uploaded through nei-directus (separate repo/
    # service — see AUTHENTICATION.md "Directus SSO"). Models with a
    # `*_asset` column resolve it to `{DIRECTUS_PUBLIC_URL}assets/{uuid}`
    # when set, falling back to their legacy string column otherwise.
    DIRECTUS_PUBLIC_URL: str = (
        "https://nei.web.ua.pt/cms/" if PRODUCTION else "http://localhost/cms/"
    )
    @field_validator("DIRECTUS_PUBLIC_URL")
    @classmethod
    def _directus_url_trailing_slash(cls, v: str) -> str:
        # Without it every asset URL silently becomes ".../cmsassets/<uuid>".
        return v if v.endswith("/") else v + "/"

    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[str] = [HOST] + (
        []
        if PRODUCTION
        else [
            "http://localhost:8001",
            "http://localhost:8002",
            "http://localhost:8003",
            "http://localhost:8004",
            "http://localhost:3000",
        ]
    )

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    def assemble_cors_origins(cls, v: str | List[str]) -> List[str] | str:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "nei"
    POSTGRES_SERVER: str = "localhost"
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "postgres"
    POSTGRES_DB: str = "postgres"
    POSTGRES_URI: str = ""
    TEST_POSTGRES_URI: str = ""

    @model_validator(mode="after")
    def populate_database_uris(self) -> "Settings":
        if self.POSTGRES_URI == "":
            self.POSTGRES_URI = (
                f"postgresql://{self.POSTGRES_USER}"
                f":{self.POSTGRES_PASSWORD}@{self.POSTGRES_SERVER}"
                f":5432/{self.POSTGRES_DB}"
            )

        if self.TEST_POSTGRES_URI == "":
            self.TEST_POSTGRES_URI = (
                f"postgresql://{self.POSTGRES_USER}"
                f":{self.POSTGRES_PASSWORD}@{self.POSTGRES_SERVER}"
                f":5432/{self.POSTGRES_DB}_test"
            )

        if not self.OIDC_REDIRECT_BASE_URL:
            self.OIDC_REDIRECT_BASE_URL = self.HOST

        return self

    # Auth settings
    ## IDP Secret Key
    IDP_KEY: str = "_82e3318ee5c5cf2c7d7f7a1367fd4b3ea40858f08a"
    IDP_SECRET_KEY: Optional[str] = None
    ## Path to JWT signing keys
    JWT_SECRET_KEY_PATH: str = "../dev-keys/jwt.key"
    JWT_PUBLIC_KEY_PATH: str = "../dev-keys/jwt.key.pub"
    ## How long access tokens are valid for
    ACCESS_TOKEN_EXPIRE: timedelta = timedelta(hours=1)
    ## How long refresh tokens are valid for
    REFRESH_TOKEN_EXPIRE: timedelta = timedelta(hours=24)
    ## How long the email confirmation tokens are valid for
    CONFIRMATION_TOKEN_EXPIRE: timedelta = timedelta(days=1)
    ## How long the password reset tokens are valid for
    PASSWORD_RESET_TOKEN_EXPIRE: timedelta = timedelta(hours=1)
    ## How long magic link tokens are valid for
    MAGIC_LINK_TOKEN_EXPIRE: timedelta = timedelta(days=1)
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"

    # Email settings
    EMAIL_ENABLED: bool = False
    ## The domain to add to the Message-id Header
    EMAIL_DOMAIN: str = "nei.web.ua.pt"
    ## Address to send email as
    EMAIL_SENDER_ADDRESS: Optional[str] = None
    ## SMTP Host address to which email requests will be made
    EMAIL_SMTP_HOST: Optional[str] = None
    ## SMTP Host port
    EMAIL_SMTP_PORT: int = 587
    ## Username to use for authentication with the smtp server
    EMAIL_SMTP_USER: Optional[str] = None
    ## Password to use for authentication with the smtp server
    EMAIL_SMTP_PASSWORD: Optional[str] = None
    ## The endpoint to point account verifications links to
    EMAIL_ACCOUNT_VERIFY_ENDPOINT: str = "/auth/verify"
    ## The endpoint to point password reset links to
    PASSWORD_RESET_ENDPOINT: str = "/auth/reset"
    ## The endpoint to point magic links to
    MAGIC_LINK_ENDPOINT: str = "/auth/magic"

    # reCaptcha settings
    RECAPTCHA_ENABLED: bool = False
    ## The reCaptcha endpoint to validate tokens
    RECAPTCHA_VERIFY_URL: str = "https://www.google.com/recaptcha/api/siteverify"
    ## The reCaptcha secret key to authenticate the backend
    RECAPTCHA_SECRET_KEY: Optional[str] = None
    ## The reCaptcha threshold for registering
    RECAPTCHA_REGISTER_THRESHOLD: float = 0.5

    # Arraial rate limiting (token bucket)
    ARRAIAL_RATE_LIMIT_PER_MINUTE: int = 180
    ARRAIAL_RATE_LIMIT_BURST: int = 60

    # OIDC/Authentik settings
    OIDC_ENABLED: bool = False  # Feature flag
    OIDC_DISCOVERY_URL: str = "https://nei.web.ua.pt/authentik/application/o/nei-platform/.well-known/openid-configuration"
    OIDC_CLIENT_ID: str = ""
    OIDC_CLIENT_SECRET: str = ""
    OIDC_SCOPES: List[str] = ["openid", "profile", "email", "nei_scopes", "nei_nmec", "nei_iupi"]
    ## Public base URL for OIDC redirect_uri and post-login frontend redirect.
    ## Defaults to HOST if not set. Set via OIDC_REDIRECT_BASE_URL env var.
    OIDC_REDIRECT_BASE_URL: str = ""
    ## TLS verification for every outbound call to Authentik. Only disable for a
    ## local Authentik with a self-signed certificate.
    OIDC_VERIFY_SSL: bool = True

    # Authentik Admin API
    AUTHENTIK_URL: str = "https://nei.web.ua.pt/authentik"
    AUTHENTIK_TOKEN: str = ""

    def _missing(self, flag: str, *names: str) -> List[str]:
        return [f"{n} is required when {flag}" for n in names if not getattr(self, n)]

    @model_validator(mode="after")
    def validate_feature_configuration(self) -> "Settings":
        """Fail at boot, not on the first request, when a feature is enabled
        without what it needs."""
        problems: List[str] = []

        if self.PRODUCTION and not self.OIDC_VERIFY_SSL:
            problems.append("OIDC_VERIFY_SSL cannot be disabled in production")
        if self.PRODUCTION and self.OIDC_ENABLED:
            problems += self._missing("OIDC_ENABLED", "OIDC_CLIENT_ID", "OIDC_CLIENT_SECRET")
        if self.EMAIL_ENABLED:
            problems += self._missing(
                "EMAIL_ENABLED", "EMAIL_SMTP_HOST", "EMAIL_SENDER_ADDRESS"
            )
        if self.RECAPTCHA_ENABLED and not self.RECAPTCHA_SECRET_KEY:
            problems.append("RECAPTCHA_SECRET_KEY is required when RECAPTCHA_ENABLED")

        if problems:
            raise ValueError("; ".join(problems))
        return self


settings = Settings()
