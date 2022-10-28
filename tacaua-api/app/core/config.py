import os
import pathlib

from pydantic import AnyHttpUrl, BaseSettings, PostgresDsn, validator
from typing import List, Optional, Union


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent



class Settings(BaseSettings):
    PRODUCTION = False
    API_V1_STR: str = "/api/v1"
    HOST: AnyHttpUrl = "http://localhost:8000"
    STATIC_URL: AnyHttpUrl = HOST + "/static"
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = ["http://localhost:3000"]

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # PostgreSQL DB
    SCHEMA_NAME: str = "tacaua"
    POSTGRES_SERVER: str = os.getenv('POSTGRES_SERVER', 'localhost')
    POSTGRES_USER: str = os.getenv('POSTGRES_USER', "postgres")
    POSTGRES_PASSWORD: str = os.getenv('POSTGRES_PASSWORD', "postgres")
    POSTGRES_DB: str = os.getenv('POSTGRES_DB', "postgres")
    SQLALCHEMY_DATABASE_URI: Optional[
        PostgresDsn
    ] = f"postgresql://{POSTGRES_USER}" \
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}" \
        f":5432/{POSTGRES_DB}"
    TEST_SQLALCHEMY_DATABASE_URI: Optional[
        PostgresDsn
    ] = f"postgresql://{POSTGRES_USER}" \
        f":{POSTGRES_PASSWORD}@{POSTGRES_SERVER}" \
        f":5432/{POSTGRES_DB}_test"

    class Config:
        case_sensitive = True


settings = Settings()
