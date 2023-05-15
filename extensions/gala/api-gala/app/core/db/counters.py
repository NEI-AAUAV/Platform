import typing
from pymongo import ReturnDocument

from .types import DBType

_TABLE_COUNTER = "tableCounter"
_VOTE_COUNTER = "voteCounter"


async def init_counters(db: DBType) -> None:
    # Initialize counters if none already exist
    await db.counters.update_one(
        {"_id": _TABLE_COUNTER}, {"$setOnInsert": {"seq": 1}}, upsert=True
    )
    await db.counters.update_one(
        {"_id": _VOTE_COUNTER}, {"$setOnInsert": {"seq": 1}}, upsert=True
    )


async def getNextTableId(db: DBType) -> int:
    res = await db.counters.find_one_and_update(
        {"_id": _TABLE_COUNTER},
        {"$inc": {"seq": 1}},
        return_document=ReturnDocument.BEFORE,
    )

    return typing.cast(int, res["seq"])


async def getNextVoteCategoryId(db: DBType) -> int:
    res = await db.counters.find_one_and_update(
        {"_id": _VOTE_COUNTER},
        {"$inc": {"seq": 1}},
        return_document=ReturnDocument.BEFORE,
    )

    return typing.cast(int, res["seq"])
