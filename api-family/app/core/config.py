import os
import pathlib

from pydantic import AnyHttpUrl, BaseSettings, MongoDsn, validator
from typing import List, Optional, Union


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent



class Settings(BaseSettings):
    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/family/v1"

    HOST: AnyHttpUrl = ("https://nei.web.ua.pt" if PRODUCTION else
                        "http://localhost:8000")
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = ["https://nei.web.ua.pt" if PRODUCTION else
                                              "http://localhost:3000"]

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # Mongo DB
    MONGO_SERVER: str = os.getenv('MONGO_SERVER', 'localhost')
    MONGO_USER: str = os.getenv('MONGO_USER', "mongo")
    MONGO_PASSWORD: str = os.getenv('MONGO_PASSWORD', "mongo")
    MONGO_DB: str = os.getenv('MONGO_DB', "mongo")
    MONGO_URI: Optional[
        MongoDsn
    ] = f"mongodb://{MONGO_USER}" \
        f":{MONGO_PASSWORD}@{MONGO_SERVER}" \
        f":27017/{MONGO_DB}?authSource={MONGO_USER}"
    TEST_MONGO_URI: Optional[
        MongoDsn
    ] = f"mongodb://{MONGO_USER}" \
        f":{MONGO_PASSWORD}@{MONGO_SERVER}" \
        f":27017/{MONGO_DB}_test??authSource={MONGO_USER}"

    # Auth settings
    ## Path to JWT signing keys
    JWT_PUBLIC_KEY_PATH: str = os.getenv("PUBLIC_KEY", "/jwt.key.pub")
    ## Algorithm to use when signing JWT tokens
    JWT_ALGORITHM: str = "ES512"

    class Config:
        case_sensitive = True

settings = Settings()
