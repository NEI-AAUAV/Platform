import os

# Tests must never touch the configured (dev/prod) database: point the app at a
# dedicated `*_test` database *before* any `app` module reads its settings.
# The auth source keeps pointing at the original database so the same
# credentials continue to work.
_configured_db = os.getenv("MONGO_DB", "mongo")
os.environ.setdefault("MONGO_AUTH_SOURCE", _configured_db)
if not _configured_db.endswith("_test"):
    os.environ["MONGO_DB"] = f"{_configured_db}_test"

import pytest
from typing import Generator, Any
from unittest.mock import patch

from fastapi import FastAPI
from fastapi.testclient import TestClient
from fastapi.responses import JSONResponse

from app.api.v1 import api_v1_router
from app.api import auth
from app.core.config import settings


# Mock payload for authenticated requests
MOCK_AUTH_PAYLOAD = {
    "sub": "test-user-id",
    "scopes": ["manager-family", "default"],
}


@pytest.fixture(scope="session")
def app() -> FastAPI:
    """Create a new application for the test session."""

    _app = FastAPI(default_response_class=JSONResponse)
    _app.include_router(api_v1_router, prefix=settings.API_V1_STR)
    return _app


@pytest.fixture
def client(
    app: FastAPI,
) -> Generator[TestClient, Any, None]:
    """Create a new TestClient that uses the `app` fixture (no auth)."""

    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()


@pytest.fixture
def auth_client(app: FastAPI) -> Generator[TestClient, Any, None]:
    """Create a new TestClient with authentication (manager-family scope).
    
    This fixture mocks the JWT decode function to always return a valid payload
    with manager-family scope, bypassing actual token validation.
    """
    
    # Mock jwt.decode to return our test payload
    with patch.object(auth, 'public_key', 'mock-key'):
        with patch('jose.jwt.decode', return_value=MOCK_AUTH_PAYLOAD):
            with TestClient(
                app, 
                headers={"Authorization": "Bearer mock-test-token"}
            ) as client:
                yield client
    
    app.dependency_overrides.clear()


@pytest.fixture(autouse=True)
def clean_database() -> Generator[None, Any, None]:
    """Give every test an empty database.

    Refuses to run against anything that is not a `*_test` database, because it
    deletes every document.
    """
    from app.db import db as database

    assert database.db.name.endswith("_test"), (
        f"refusing to wipe non-test database {database.db.name!r}"
    )
    collections = (
        database.Counter,
        database.User,
        database.Course,
        database.Organization,
        database.Role,
        database.UserRole,
    )
    for collection in collections:
        collection.delete_many({})
    yield
    for collection in collections:
        collection.delete_many({})
