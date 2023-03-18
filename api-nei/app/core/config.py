import os
import pathlib

from datetime import timedelta
from pydantic import AnyHttpUrl, BaseSettings, PostgresDsn, validator
from typing import List, Optional, Union


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/nei/v1"
    STATIC_STR: str = "/static/nei"

    HOST: AnyHttpUrl = "https://nei.web.ua.pt" if PRODUCTION else "http://localhost"
    STATIC_URL: AnyHttpUrl = HOST + STATIC_STR
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = (
        ["https://nei.web.ua.pt"]
        if PRODUCTION
        else ["http://localhost", "http://localhost:8001", "http://localhost:8002"]
    )

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "nei"
    POSTGRES_SERVER: str = os.getenv("POSTGRES_SERVER", "localhost")
    POSTGRES_USER: str = os.getenv("POSTGRES_USER", "postgres")
    POSTGRES_PASSWORD: str = os.getenv("POSTGRES_PASSWORD", "postgres")
    POSTGRES_DB: str = os.getenv("POSTGRES_DB", "postgres")
    POSTGRES_URI: Optional[PostgresDsn] = (
        f"postgresql://{POSTGRES_USER}"
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}"
        f":5432/{POSTGRES_DB}"
    )
    TEST_POSTGRES_URI: Optional[PostgresDsn] = (
        f"postgresql://{POSTGRES_USER}"
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}"
        f":5432/{POSTGRES_DB}_test"
    )

    # Auth settings
    ## Path to JWT signing keys
    JWT_SECRET_KEY_PATH: str = os.getenv("SECRET_KEY", "../dev-keys/jwt.key")
    JWT_PUBLIC_KEY_PATH: str = os.getenv("PUBLIC_KEY", "../dev-keys/jwt.key.pub")
    ## How long access tokens are valid for
    ACCESS_TOKEN_EXPIRE: timedelta = timedelta(minutes=10)
    ## How long refresh tokens are valid for
    REFRESH_TOKEN_EXPIRE: timedelta = timedelta(days=7)
    ## How long the email confirmation tokens are valid for
    CONFIRMATION_TOKEN_EXPIRE: timedelta = timedelta(days=1)
    ## How long the password reset tokens are valid for
    PASSWORD_RESET_TOKEN_EXPIRE = timedelta(hours=1)
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"

    # Email settings
    EMAIL_ENABLED: bool = os.getenv("EMAIL_ENABLED", "False") == "True"
    ## The domain to add to the Message-id Header
    EMAIL_DOMAIN: str = "nei.web.ua.pt"
    ## Address to send email as
    EMAIL_SENDER_ADDRESS: str = os.getenv("EMAIL_SENDER_ADDRESS")
    ## SMTP Host address to which email requests will be made
    EMAIL_SMTP_HOST: str = os.getenv("EMAIL_SMTP_HOST")
    ## SMTP Host port
    EMAIL_SMTP_PORT: int = int(os.getenv("EMAIL_SMTP_PORT", 587))
    ## Username to use for authentication with the smtp server
    EMAIL_SMTP_USER: str = os.getenv("EMAIL_SMTP_USER")
    ## Password to use for authentication with the smtp server
    EMAIL_SMTP_PASSWORD: str = os.getenv("EMAIL_SMTP_PASSWORD")
    ## The endpoint to point account verifications links to
    EMAIL_ACCOUNT_VERIFY_ENDPOINT: str = os.getenv(
        "EMAIL_ACCOUNT_VERIFY_ENDPOINT", "/auth/verify"
    )
    ## The endpoint to point password reset links to
    PASSWORD_RESET_ENDPOINT: str = os.getenv("PASSWORD_RESET_ENDPOINT", "/auth/reset")

    class Config:
        case_sensitive = True


settings = Settings()
