import os
import pathlib
from urllib.parse import urljoin
from functools import lru_cache

from fastapi import Depends
from typing import Annotated, Any, List, TypeAlias, Union
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import AnyHttpUrl, PostgresDsn, field_validator

# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(case_sensitive=True)

    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/rally/v1"
    STATIC_STR: str = "/static/rally"

    HOST: AnyHttpUrl = AnyHttpUrl(
        "https://nei.web.ua.pt" if PRODUCTION else "http://localhost:8000"
    )
    STATIC_URL: AnyHttpUrl = AnyHttpUrl(urljoin(str(HOST), STATIC_STR))
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = [
        AnyHttpUrl("https://nei.web.ua.pt" if PRODUCTION else "http://localhost:3000")
    ]

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: Any) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "rally_tascas"
    POSTGRES_SERVER: str = os.getenv("POSTGRES_SERVER", "localhost")
    POSTGRES_USER: str = os.getenv("POSTGRES_USER", "postgres")
    POSTGRES_PASSWORD: str = os.getenv("POSTGRES_PASSWORD", "postgres")
    POSTGRES_DB: str = os.getenv("POSTGRES_DB", "postgres")
    POSTGRES_URI: PostgresDsn = PostgresDsn(
        f"postgresql://{POSTGRES_USER}"
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}"
        f":5432/{POSTGRES_DB}"
    )
    TEST_POSTGRES_URI: PostgresDsn = PostgresDsn(
        f"postgresql://{POSTGRES_USER}"
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}"
        f":5432/{POSTGRES_DB}_test"
    )

    # Auth settings
    ## Path to JWT signing keys
    JWT_PUBLIC_KEY_PATH: str = os.getenv(
        "JWT_PUBLIC_KEY_PATH", "../../../dev-keys/jwt.key.pub"
    )
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"


settings = Settings()


@lru_cache
def get_settings() -> Settings:
    return Settings()


SettingsDep: TypeAlias = Annotated[Settings, Depends(get_settings)]
