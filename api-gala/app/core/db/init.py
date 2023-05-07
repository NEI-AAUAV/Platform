from pymongo.errors import CollectionInvalid

from app.models.user import User
from app.models.table import Table
from app.core.logging import logger

from ._validators.table import table_validator
from .types import DBType
from .counters import init_counters


async def init_db(db: DBType) -> None:
    await init_counters(db)

    try:
        await db.create_collection(User.collection(), check_exists=True)
        await db.create_collection(Table.collection(), check_exists=True)
    except CollectionInvalid:
        logger.debug("Collection already exist")

    await Table.get_collection(db).create_index("persons.id")
    await db.command(
        {
            "collMod": Table.collection(),
            "validator": table_validator,
        },
    )
