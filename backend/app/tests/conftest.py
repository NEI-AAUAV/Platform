import pytest
from typing import Generator, Any

from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
from sqlalchemy.engine import Connection

from app.api.deps import get_db
from app.api.api_v1.api import api_router
from app.core.config import settings
from app.db.base_class import Base

# Since we import .main, the code in it will be executed,
# including the definition of the table models.
#
# This hack will automatically register the tables in Base.metadata.
import app.main


# Create a SQLite database specifically for testing and
# keep the original database untouched.
#
# A in memory database is faster and more secure.
# SQLITE_DB = "./test_db.db"
SQLITE_DB = ":memory:"
SQLALCHEMY_DATABASE_URI = "sqlite:///" + SQLITE_DB
engine = create_engine(
    SQLALCHEMY_DATABASE_URI, connect_args={"check_same_thread": False},
    poolclass=StaticPool
)
SessionTesting = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="session")
def connection():
    """Create a new database for the test session.

    This only executes once for all tests.
    """
    connection = engine.connect()
    connection.execute(
        f'ATTACH DATABASE \'{SQLITE_DB}\' AS {settings.SCHEMA_NAME};')
    # Create the tables
    Base.metadata.create_all(bind=engine, checkfirst=True)
    yield connection
    Base.metadata.drop_all(engine)
    connection.execute(f'DETACH DATABASE \'{settings.SCHEMA_NAME}\';')
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

    _app = FastAPI()
    _app.include_router(api_router, prefix=settings.API_V1_STR)
    yield _app


@pytest.fixture(scope="function")
def client(
    app: FastAPI,
    db: SessionTesting
) -> Generator[TestClient, Any, None]:
    """Create a new TestClient that uses the `app` and `db` fixture.

    The `db` fixture will override the `get_db` dependency that is
    injected into routes.
    """
    def _get_test_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = _get_test_db
    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()
