from app.core.db.types import DBType
from app.models.limits import LIMITS_ID, Limits


async def fetch_limits(db: DBType) -> Limits:
    res = await Limits.get_collection(db).find_one({"_id": LIMITS_ID})
    return Limits.parse_obj(res)
