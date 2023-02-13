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

    HOST: AnyHttpUrl = ("https://nei.web.ua.pt" if PRODUCTION else
                        "http://localhost")
    STATIC_URL: AnyHttpUrl = HOST + STATIC_STR
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = ["https://nei.web.ua.pt" if PRODUCTION else
                                              "http://localhost"]

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "nei"
    POSTGRES_SERVER: str = os.getenv('POSTGRES_SERVER', 'localhost')
    POSTGRES_USER: str = os.getenv('POSTGRES_USER', "postgres")
    POSTGRES_PASSWORD: str = os.getenv('POSTGRES_PASSWORD', "postgres")
    POSTGRES_DB: str = os.getenv('POSTGRES_DB', "postgres")
    POSTGRES_URI: Optional[
        PostgresDsn
    ] = f"postgresql://{POSTGRES_USER}" \
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}" \
        f":5432/{POSTGRES_DB}"
    TEST_POSTGRES_URI: Optional[
        PostgresDsn
    ] = f"postgresql://{POSTGRES_USER}" \
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}" \
        f":5432/{POSTGRES_DB}_test"

    # Auth settings
    ## Secret key to sign JWT tokens with
    JWT_SECRET_KEY: str | None = os.getenv(
        "SECRET_KEY",
        # Don't use this in production :)
        "c35eb2f4dbfdb35f98155ae2f65625ba9470d1f204e5d5e1f020ff9fa7248e0b",
    )
    ## How long access tokens are valid for
    ACCESS_TOKEN_EXPIRE: timedelta = timedelta(minutes=30)
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "HS256"

    class Config:
        case_sensitive = True


settings = Settings()
