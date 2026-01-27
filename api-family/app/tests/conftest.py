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
