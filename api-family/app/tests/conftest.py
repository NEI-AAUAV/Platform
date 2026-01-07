import pytest
from typing import Generator, Any

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


async def mock_verify_scopes(*args, **kwargs):
    """Mock verify_scopes that always returns a valid payload with manager-family scope."""
    return MOCK_AUTH_PAYLOAD


@pytest.fixture(scope="session")
def app() -> Generator[FastAPI, Any, None]:
    """Create a new application for the test session."""

    _app = FastAPI(default_response_class=JSONResponse)
    _app.include_router(api_v1_router, prefix=settings.API_V1_STR)
    yield _app


@pytest.fixture(scope="function")
def client(
    app: FastAPI,
) -> Generator[TestClient, Any, None]:
    """Create a new TestClient that uses the `app` fixture (no auth)."""

    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()


@pytest.fixture(scope="function")
def auth_client() -> Generator[TestClient, Any, None]:
    """Create a new TestClient with authentication (manager-family scope).
    
    This fixture creates its own app instance with auth already mocked,
    to avoid issues with FastAPI's Security dependency resolution.
    """
    
    # Create a new app instance for authenticated tests
    _app = FastAPI(default_response_class=JSONResponse)
    
    # Override auth BEFORE including the router
    _app.dependency_overrides[auth.verify_scopes] = mock_verify_scopes
    
    # Include router
    _app.include_router(api_v1_router, prefix=settings.API_V1_STR)
    
    with TestClient(_app) as client:
        yield client
    
    _app.dependency_overrides.clear()


