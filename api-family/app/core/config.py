import os
import pathlib

from pydantic import AnyHttpUrl, BaseSettings, MongoDsn, root_validator, validator
from typing import List, Optional, Union


# Project Directories
ROOT = pathlib.Path(__file__).resolve().parent.parent



class Settings(BaseSettings):
    PRODUCTION: bool = os.getenv("ENV") == "production"

    API_V1_STR: str = "/api/family/v1"

    HOST: AnyHttpUrl = ("https://nei.web.ua.pt" if PRODUCTION else
                        "http://localhost:8000")
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

    @root_validator
    def build_mongo_uris(cls, values):
        """Build MongoDB URIs with authSource after all fields are validated"""
        auth_source = values.get('MONGO_AUTH_SOURCE') or values.get('MONGO_DB', 'mongo')
        mongo_user = values.get('MONGO_USER', 'mongo')
        mongo_password = values.get('MONGO_PASSWORD', 'mongo')
        mongo_server = values.get('MONGO_SERVER', 'localhost')
        mongo_db = values.get('MONGO_DB', 'mongo')
        
        values['MONGO_AUTH_SOURCE'] = auth_source
        values['MONGO_URI'] = f"mongodb://{mongo_user}" \
                              f":{mongo_password}@{mongo_server}" \
                              f":27017/{mongo_db}?authSource={auth_source}"
        values['TEST_MONGO_URI'] = f"mongodb://{mongo_user}" \
                                   f":{mongo_password}@{mongo_server}" \
                                   f":27017/{mongo_db}_test?authSource={auth_source}"
        return values

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

    class Config:
        case_sensitive = True

settings = Settings()
