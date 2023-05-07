from aiocache.decorators import cached
import pytest
import typing
import pytest_asyncio

from httpx import AsyncClient
from functools import lru_cache
from fastapi import HTTPException
from asgi_lifespan import LifespanManager
from collections.abc import AsyncGenerator
from fastapi.security import SecurityScopes

from app.main import app
from app.core.config import Settings, SettingsDep, get_settings
from app.core.db import ClientDep, get_client, get_db, DatabaseClient
from app.core.db.types import DBType
from app.api.auth import AuthData, ScopeEnum, api_nei_auth


phase_report_key = pytest.StashKey[typing.Dict[str, pytest.CollectReport]]()


# Source: https://docs.pytest.org/en/latest/example/simple.html#making-test-result-information-available-in-fixtures
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
@typing.no_type_check
def pytest_runtest_makereport(item):
    # execute all other hooks to obtain the report object
    outcome = yield
    rep = outcome.get_result()

    # store test results for each phase of a call, which can
    # be "setup", "call", "teardown"
    item.stash.setdefault(phase_report_key, {})[rep.when] = rep


@pytest.fixture(scope="function")
def settings(request: pytest.FixtureRequest) -> Settings:
    return Settings(MONGO_DB=f"test-database-{request.node.name}")


@pytest_asyncio.fixture(scope="function")
def db_client(settings: Settings) -> DatabaseClient:
    class MockClient(DatabaseClient):
        def close(self) -> None:
            pass

    return MockClient(settings)


@pytest_asyncio.fixture(scope="function")
def db(settings: Settings, db_client: DatabaseClient) -> DBType:
    return db_client.client()[settings.MONGO_DB]


@pytest_asyncio.fixture(scope="function", autouse=True)
async def clean_db(
    request: pytest.FixtureRequest, settings: Settings, db_client: DatabaseClient
) -> AsyncGenerator[None, None]:
    await db_client.client().drop_database(settings.MONGO_DB)
    yield
    report = request.node.stash[phase_report_key]
    if not report["setup"].failed:
        await db_client.client().drop_database(settings.MONGO_DB)


@pytest_asyncio.fixture(scope="function")
async def client(
    request: pytest.FixtureRequest,
    settings: Settings,
    db_client: DatabaseClient,
    db: DBType,
) -> AsyncGenerator[AsyncClient, None]:
    auth_data: AuthData = typing.cast(AuthData, getattr(request, "param", None))

    def pass_trough_auth(security_scopes: SecurityScopes) -> AuthData:
        if ScopeEnum.ADMIN in auth_data.scopes:
            return auth_data

        for scope in security_scopes.scopes:
            if scope not in auth_data.scopes:
                raise HTTPException(status_code=403)

        return auth_data

    @lru_cache
    def override_get_settings() -> Settings:
        return settings

    @cached()
    async def override_get_client(_settings: SettingsDep) -> DatabaseClient:
        return db_client

    @cached()
    async def override_get_db(_settings: SettingsDep, _client: ClientDep) -> DBType:
        return db

    app.dependency_overrides[get_client] = override_get_client
    app.dependency_overrides[get_db] = override_get_db
    app.dependency_overrides[get_settings] = override_get_settings
    if auth_data:
        app.dependency_overrides[api_nei_auth] = pass_trough_auth

    async with LifespanManager(app):
        async with AsyncClient(
            app=app, base_url="http://test", follow_redirects=True
        ) as client:
            yield client

    app.dependency_overrides.clear()
