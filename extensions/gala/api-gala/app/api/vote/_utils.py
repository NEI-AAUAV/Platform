from fastapi import HTTPException

from app.api.auth import AuthData
from app.core.db.types import DBType
from app.models.vote import VoteCategory, VoteListing


async def fetch_category(category_id: int, db: DBType) -> VoteCategory:
    res = await VoteCategory.get_collection(db).find_one({"_id": category_id})

    if res is None:
        raise HTTPException(status_code=404, detail="Category not found")

    return VoteCategory.parse_obj(res)


def anonymize_category(category: VoteCategory, auth: AuthData) -> VoteListing:
    already_voted = False
    scores = [0] * len(category.options)

    for vote in category.votes:
        scores[vote.option] += 1
        already_voted |= vote.uid == auth.sub

    return VoteListing(
        _id=category.id,
        category=category.category,
        options=category.options,
        scores=scores,
        already_voted=already_voted,
    )
