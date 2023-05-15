from typing import Any, List
from fastapi import APIRouter, Security

from app.api.auth import AuthData, api_nei_auth
from app.core.db import DatabaseDep
from app.models.vote import VoteCategory, VoteListing

from ._utils import fetch_category

router = APIRouter()


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


@router.get("/list")
async def list_categories(
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> List[VoteListing]:
    """Lists all vote categories"""
    res = await VoteCategory.get_collection(db).find().to_list(None)

    def mapper(category_res: Any) -> VoteListing:
        category = VoteCategory(**category_res)
        return anonymize_category(category, auth)

    return list(map(mapper, res))


@router.get("/{category_id}")
async def get_category(
    category_id: int,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> VoteListing:
    """Get a single vote category"""
    category = await fetch_category(category_id, db)
    return anonymize_category(category, auth)
