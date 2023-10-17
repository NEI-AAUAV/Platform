import pytest
import typing
from typing import Generator, Any

from fastapi import FastAPI
from fastapi.testclient import TestClient
from fastapi.responses import ORJSONResponse
from sqlalchemy import create_engine, inspect
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.engine import Connection
from sqlalchemy.schema import CreateSchema

from app.api.deps import get_db, get_current_user
from app.api.api import api_v1_router
from app.core.config import settings
from app.models import Base, User


# Create a PostgreSQL DB specifically for testing and
# keep the original DB untouched.
#
# Add echo=True in `create_engine` to log all DB commands made
engine = create_engine(str(settings.TEST_POSTGRES_URI))
SessionTesting = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="session")
def connection():
    """Create a new database for the test session.

    This only executes once for all tests.
    """
    inspector = inspect(engine)
    connection = engine.connect()
    all_schemas = inspector.get_schema_names()
    for schema in Base.metadata._schemas:
        if schema not in all_schemas:
            connection.execute(CreateSchema(schema))
            connection.commit()

    Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
    Base.metadata.create_all(bind=engine, checkfirst=True)
    yield connection
    Base.metadata.drop_all(engine)
    connection.close()


@pytest.fixture(scope="function")
def db(connection: Connection) -> Generator[Session, Any, None]:
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
def client(
    request: pytest.FixtureRequest, app: FastAPI, db: Session
) -> Generator[TestClient, Any, None]:
    """Create a new TestClient that uses the `app` and `db` fixture.

    The `db` fixture will override the `get_db` dependency that is
    injected into routes.
    """
    user: User = typing.cast(User, getattr(request, "param", None))

    def pass_trough_auth() -> User:
        return user

    def _get_test_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = _get_test_db
    if user:
        app.dependency_overrides[get_current_user] = pass_trough_auth
    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()
