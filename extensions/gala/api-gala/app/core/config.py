from functools import lru_cache
import os
import pathlib
from fastapi import Depends

from pydantic import BaseSettings
from typing import Annotated, List, TypeAlias, Optional


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/gala/v1"
    STATIC_STR: str = "/static/gala"

    HOST: str = "https://nei.web.ua.pt" if PRODUCTION else "http://localhost"
    STATIC_URL: str = HOST + STATIC_STR
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[str] = (
        [HOST] + [] if PRODUCTION else ["http://localhost:3000"]
    )

    # Mongo DB
    MONGO_SERVER: str = os.getenv("MONGO_SERVER", "localhost")
    MONGO_USER: str = os.getenv("MONGO_USER", "mongo")
    MONGO_PASSWORD: str = os.getenv("MONGO_PASSWORD", "mongo")
    MONGO_DB: str = os.getenv("MONGO_DB", "mongo")

    # Auth settings
    ## Path to JWT signing keys
    JWT_PUBLIC_KEY_PATH: str = os.getenv(
        "JWT_PUBLIC_KEY_PATH", "../../../dev-keys/jwt.key.pub"
    )
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"

    # Email settings
    EMAIL_ENABLED: bool = os.getenv("EMAIL_ENABLED", "False") == "True"
    ## The domain to add to the Message-id Header
    EMAIL_DOMAIN: str = "nei.web.ua.pt"
    ## Address to send email as
    EMAIL_SENDER_ADDRESS: Optional[str] = os.getenv("EMAIL_SENDER_ADDRESS")
    ## SMTP Host address to which email requests will be made
    EMAIL_SMTP_HOST: Optional[str] = os.getenv("EMAIL_SMTP_HOST")
    ## SMTP Host port
    EMAIL_SMTP_PORT: int = int(os.getenv("EMAIL_SMTP_PORT", 587))
    ## Username to use for authentication with the smtp server
    EMAIL_SMTP_USER: Optional[str] = os.getenv("EMAIL_SMTP_USER")
    ## Password to use for authentication with the smtp server
    EMAIL_SMTP_PASSWORD: Optional[str] = os.getenv("EMAIL_SMTP_PASSWORD")

    ALLOW_TIME_SLOTS_PAST: bool = os.getenv("ALLOW_TIME_SLOTS_PAST", "False") == "True"

    class Config:
        frozen = True
        case_sensitive = True
        env_file = ".env"


@lru_cache
def get_settings() -> Settings:
    return Settings()


SettingsDep: TypeAlias = Annotated[Settings, Depends(get_settings)]
