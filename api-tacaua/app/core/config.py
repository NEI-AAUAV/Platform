import os
import pathlib
from typing import List, Union

from pydantic import (
    field_validator,
    model_validator,
)
from pydantic_settings import BaseSettings, SettingsConfigDict


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=True
    )

    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/tacaua/v1"
    STATIC_STR: str = "/static/tacaua"

    HOST: str = "https://nei.web.ua.pt" if PRODUCTION else "http://localhost:8000"
    STATIC_URL: str = HOST + STATIC_STR
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[str] = [HOST] + (
        [] if PRODUCTION else ["http://localhost:3000"]
    )

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "tacaua"
    API_NEI_SERVER: str = "localhost"
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
    ## Path to JWT signing keys
    JWT_PUBLIC_KEY_PATH: str = os.getenv("PUBLIC_KEY", "../dev-keys/jwt.key.pub")
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"


settings = Settings()