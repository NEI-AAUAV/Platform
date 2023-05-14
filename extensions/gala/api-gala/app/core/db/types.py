from typing import TypeAlias
from motor.motor_asyncio import (
    AsyncIOMotorCollection,
    AsyncIOMotorDatabase,
)

DBType: TypeAlias = AsyncIOMotorDatabase
CollectionType: TypeAlias = AsyncIOMotorCollection
