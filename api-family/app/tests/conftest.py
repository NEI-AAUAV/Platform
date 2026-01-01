import pytest
from typing import Generator, Any

from fastapi import FastAPI
from fastapi.testclient import TestClient
from fastapi.responses import JSONResponse

from app.api.v1 import api_v1_router
from app.core.config import settings


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
    """Create a new TestClient that uses the `app` fixture."""

    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()
