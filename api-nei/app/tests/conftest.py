import typing
from pathlib import Path

from fastapi.security import SecurityScopes
import pytest
from typing import Generator, Any

from alembic import command
from alembic.config import Config
from fastapi import FastAPI
from fastapi.testclient import TestClient
from fastapi.responses import ORJSONResponse
import sqlalchemy as sa
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.engine import Connection

from app.api.deps import get_db
from app.api.api_v1.auth import AuthData, get_auth_data
from app.api.api_v1 import router as api_v1_router
from app.core.config import settings

# Since we import app.main, the code in it will be executed,
# including the definition of the table models.
#
# This hack will automatically register the tables in Base.metadata.
import app.main
from app.schemas.user.user import ScopeEnum


# Create a PostgreSQL DB specifically for testing and
# keep the original DB untouched.
#
# Add echo=True in `create_engine` to log all DB commands made
engine = create_engine(settings.TEST_POSTGRES_URI)
SessionTesting = sessionmaker(engine, autoflush=False)

ALEMBIC_INI = Path(__file__).resolve().parents[2] / "alembic.ini"


def _alembic_config() -> Config:
    """Point Alembic at the same DB the test session engine uses.

    Using the real migration chain (instead of `Base.metadata.create_all`)
    means the test suite actually exercises `alembic upgrade head` — a
    broken migration now fails CI instead of going unnoticed.
    """
    cfg = Config(str(ALEMBIC_INI))
    cfg.set_main_option("sqlalchemy.url", settings.TEST_POSTGRES_URI)
    return cfg


@pytest.fixture(scope="session")
def connection():
    """Create a new database for the test session.

    This only executes once for all tests. Uses the real Alembic chain
    (`alembic upgrade head`) instead of `Base.metadata.create_all`, so a
    broken migration fails the test suite instead of going unnoticed.

    Teardown drops the whole `nei` schema rather than running
    `alembic downgrade base`, which is simpler, faster and does not depend
    on every downgrade() being individually correct.
    """
    command.upgrade(_alembic_config(), "head")
    with engine.connect() as connection:
        yield connection
        connection.close()
    with engine.connect() as cleanup:
        cleanup.execute(sa.text(f"DROP SCHEMA IF EXISTS {settings.SCHEMA_NAME} CASCADE"))
        cleanup.commit()


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
    auth_data: AuthData = typing.cast(AuthData, getattr(request, "param", None))

    def pass_trough_auth() -> AuthData:
        return auth_data

    def _get_test_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = _get_test_db
    if auth_data:
        app.dependency_overrides[get_auth_data] = pass_trough_auth

    with TestClient(app) as client:
        yield client

    app.dependency_overrides.clear()
