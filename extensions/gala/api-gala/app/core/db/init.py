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

    # Create an index over the `id` of the persons documents stored in a table.
    #
    # This index is marked as unique to guarantee that a person doesn't enter multiple
    # tables at the same time. Mongo doesn't check it against documents in the same array
    # so that needs to be manually verified.
    #
    # The index is also marked as `sparse` so that empty tables don't conflict with each other.
    await Table.get_collection(db).create_index("persons.id", unique=True, sparse=True)
    await db.command(
        {
            "collMod": Table.collection(),
            "validator": table_validator,
        },
    )
