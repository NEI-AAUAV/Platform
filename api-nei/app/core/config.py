import os
import pathlib

from datetime import timedelta
from pydantic import field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List, Optional, Union


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
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
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
    REFRESH_TOKEN_EXPIRE: timedelta = timedelta(days=7)
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


settings = Settings()
