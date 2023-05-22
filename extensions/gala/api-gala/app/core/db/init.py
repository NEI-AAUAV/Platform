from datetime import datetime
from pymongo import collation
from pymongo.errors import CollectionInvalid

from app.models.user import User
from app.models.table import Table
from app.models.time_slots import TimeSlots, TIME_SLOTS_ID
from app.core.logging import logger
from app.models.vote import VoteCategory

from ._validators.table import table_validator
from ._validators.vote import vote_validator
from .types import DBType
from .counters import init_counters


async def init_db(db: DBType) -> None:
    await init_counters(db)

    try:
        await db.create_collection(User.collection(), check_exists=True)
    except CollectionInvalid:
        logger.debug("Users collection already exist")

    try:
        await db.create_collection(Table.collection(), check_exists=True)
    except CollectionInvalid:
        logger.debug("Tables collection already exist")

    try:
        await db.create_collection(VoteCategory.collection(), check_exists=True)
    except CollectionInvalid:
        logger.debug("Vote category collection already exist")

    try:
        await db.create_collection(TimeSlots.collection(), check_exists=True)
    except CollectionInvalid:
        logger.debug("Time slots category collection already exist")

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

    # Create an index over the `category` name of the vote category.
    #
    # This index is marked as unique to guarantee that multiple categories with the same name
    # aren't created.
    #
    # The index also uses a collation in Portuguese with the ICU comparison level of primary,
    # this makes it so that the index doesn't care about case sensitivity nor punctuation, this
    # makes it harder for the same category to be created twice by mistake.
    await VoteCategory.get_collection(db).create_index(
        "category",
        unique=True,
        collation=collation.Collation(
            locale="pt", strength=collation.CollationStrength.PRIMARY
        ),
    )
    await db.command(
        {
            "collMod": VoteCategory.collection(),
            "validator": vote_validator,
        },
    )

    time_slot = TimeSlots(
        votesStart=datetime(1970, 1, 1),
        votesEnd=datetime(1970, 1, 1),
        tablesStart=datetime(1970, 1, 1),
        tablesEnd=datetime(1970, 1, 1),
    )
    await TimeSlots.get_collection(db).update_one(
        {"_id": TIME_SLOTS_ID}, {"$setOnInsert": time_slot.dict()}, upsert=True
    )
