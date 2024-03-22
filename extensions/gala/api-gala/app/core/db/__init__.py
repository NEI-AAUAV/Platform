from fastapi import Depends
from typing import Annotated, TypeAlias, no_type_check
from motor.motor_asyncio import AsyncIOMotorClient
from aiocache import cached

from app.core.config import Settings, SettingsDep
from app.core.logging import logger

from .types import DBType


class DatabaseClient:
    _client: AsyncIOMotorClient

    def __init__(self, settings: Settings) -> None:
        self._client = AsyncIOMotorClient(
            settings.MONGO_SERVER,
            27017,
            username=settings.MONGO_USER,
            password=settings.MONGO_PASSWORD,
        )

    def client(self) -> AsyncIOMotorClient:
        return self._client

    def close(self) -> None:
        logger.info("Closing MongoDB connection.")
        self._client.close()


@cached()
@no_type_check
async def get_client(settings: SettingsDep) -> DatabaseClient:
    return DatabaseClient(settings)


ClientDep: TypeAlias = Annotated[DatabaseClient, Depends(get_client)]


@cached()
@no_type_check
async def get_db(settings: SettingsDep, client: ClientDep) -> DBType:
    logger.info("Connected to MongoDB.")
    return client.client()[settings.MONGO_DB]


DatabaseDep: TypeAlias = Annotated[DBType, Depends(get_db)]
