import pytest
from typing import Generator, Any
import requests
from fastapi import FastAPI
from fastapi.testclient import TestClient
from fastapi.responses import ORJSONResponse
from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine import Connection
from sqlalchemy.schema import CreateSchema

from app.api.deps import get_db
from app.api.auth import verify_scopes
from app.api.api import api_v1_router
from app.core.config import settings
from app.db.base_class import Base
from app.api.v1.match import ws_send_update

# Since we import app.main, the code in it will be executed,
# including the definition of the table models.
#
# This hack will automatically register the tables in Base.metadata.
import app.main


# Create a PostgreSQL DB specifically for testing and
# keep the original DB untouched.
#
# Add echo=True in `create_engine` to log all DB commands made
engine = create_engine(settings.TEST_POSTGRES_URI)
SessionTesting = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="session")
def connection():
    """Create a new database for the test session.

    This only executes once for all tests.
    """
    connection = engine.connect()
    if not engine.dialect.has_schema(connection, schema=settings.SCHEMA_NAME):
        event.listen(
            Base.metadata,
            "before_create",
            CreateSchema(settings.SCHEMA_NAME),
            insert=True,
        )

    Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
    Base.metadata.create_all(bind=engine, checkfirst=True)
    connection.commit()
    yield connection
    Base.metadata.drop_all(engine)
    connection.close()


@pytest.fixture(scope="function")
def db(connection: Connection) -> Generator[SessionTesting, Any, None]:
    """Reset/rollback the changes in the database tables.

    It is common to also recreate a new database for every test, but
    only a rollback is faster and sufficient.
    """
    transaction = connection.begin()
    session = SessionTesting(bind=connection)
    yield session  # Use the session in tests
    session.close()
    transaction.rollback()


@pytest.fixture(scope="session")
def app() -> Generator[FastAPI, Any, None]:
    """Create a new application for the test session."""

    _app = FastAPI(default_response_class=ORJSONResponse)
    _app.include_router(api_v1_router, prefix=settings.API_V1_STR)
    yield _app


@pytest.fixture(scope="function")
def client(request, app: FastAPI, db: SessionTesting) -> Generator[TestClient, Any, None]:
    """Create a new TestClient that uses the `app` and `db` fixture.

    The `db` fixture will override the `get_db` dependency that is
    injected into routes.
    """

    def _get_test_db():
        try:
            yield db
        finally:
            pass

    def _verify_scopes():
        return {
            "iat": 0,
            "exp": 600,
            "sub": 1,
            "nmec": None,
            "name": "NEI",
            "surname": "AAUAv",
            "scopes": [request.param["scope"]],
        }

    def _ws_send_update(data):
        data = requests.post(
            f"http://{settings.API_NEI_SERVER}:8000/api/nei/v1/ws/broadcast", data
        )
        assert data["status"] == "success"

    app.dependency_overrides[get_db] = _get_test_db
    app.dependency_overrides[verify_scopes] = _verify_scopes
    app.dependency_overrides[ws_send_update] = _ws_send_update

    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()
