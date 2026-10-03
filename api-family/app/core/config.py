import json
import os
import pathlib

from pydantic import AnyHttpUrl, MongoDsn, field_validator, model_validator
from pydantic_settings import BaseSettings, NoDecode, SettingsConfigDict
from typing import Annotated, List, Optional


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent



class Settings(BaseSettings):
    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/family/v1"

    HOST: AnyHttpUrl = ("https://nei.web.ua.pt" if PRODUCTION else
                        "http://localhost:8000")
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: Annotated[List[str], NoDecode] = (
        ["https://nei.web.ua.pt"]
        if PRODUCTION
        else ["http://localhost", "http://localhost:8001", "http://localhost:8002"]
    )

    @field_validator("BACKEND_CORS_ORIGINS", mode="before")
    @classmethod
    def assemble_cors_origins(cls, v: str | List[str]) -> List[str] | str:
        if isinstance(v, str):
            v = json.loads(v) if v.startswith("[") else [i.strip() for i in v.split(",")]
        if isinstance(v, list):
            # Origins are compared as plain strings by CORSMiddleware: no trailing slash
            return [str(i).rstrip("/") for i in v]
        if isinstance(v, str):
            return v
        raise ValueError(v)

    # Mongo DB
    MONGO_SERVER: str = os.getenv('MONGO_SERVER', 'localhost')
    MONGO_USER: str = os.getenv('MONGO_USER', "mongo")
    MONGO_PASSWORD: str = os.getenv('MONGO_PASSWORD', "mongo")
    MONGO_DB: str = os.getenv('MONGO_DB', "mongo")
    # authSource is the database name where user credentials are stored
    # For root users: "admin", for dedicated users: database name (MONGO_DB)
    # Defaults to MONGO_DB (production), can be overridden to "admin" for development
    MONGO_AUTH_SOURCE: Optional[str] = os.getenv('MONGO_AUTH_SOURCE')
    MONGO_URI: Optional[MongoDsn] = None
    TEST_MONGO_URI: Optional[MongoDsn] = None

    @model_validator(mode="after")
    def build_mongo_uris(self):
        """Build MongoDB URIs with authSource after all fields are validated"""
        auth_source = self.MONGO_AUTH_SOURCE or self.MONGO_DB
        self.MONGO_AUTH_SOURCE = auth_source
        base = f"mongodb://{self.MONGO_USER}:{self.MONGO_PASSWORD}@{self.MONGO_SERVER}:27017"
        self.MONGO_URI = f"{base}/{self.MONGO_DB}?authSource={auth_source}"
        self.TEST_MONGO_URI = f"{base}/{self.MONGO_DB}_test?authSource={auth_source}"
        return self

    # Auth settings
    ## Path to JWT signing keys
    JWT_PUBLIC_KEY_PATH: str = os.getenv("PUBLIC_KEY", "../dev-keys/jwt.key.pub")
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"

    # Cloudflare R2 (S3 compatible) for images
    R2_ENDPOINT_URL: Optional[str] = os.getenv("R2_ENDPOINT_URL")
    R2_ACCESS_KEY_ID: Optional[str] = os.getenv("R2_ACCESS_KEY_ID")
    R2_SECRET_ACCESS_KEY: Optional[str] = os.getenv("R2_SECRET_ACCESS_KEY")
    R2_BUCKET: Optional[str] = os.getenv("R2_BUCKET")
    # Public base URL to serve images (e.g., https://cdn.example.com)
    R2_PUBLIC_BASE_URL: Optional[str] = os.getenv("R2_PUBLIC_BASE_URL")

    model_config = SettingsConfigDict(case_sensitive=True)

settings = Settings()
