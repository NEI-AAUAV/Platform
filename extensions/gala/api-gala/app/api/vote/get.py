from typing import Any, List
from fastapi import APIRouter, Security

from app.api.auth import AuthData, ScopeEnum, api_nei_auth, auth_responses
from app.core.db import DatabaseDep
from app.models.vote import Vote, VoteCategory, VoteListing

from ._utils import fetch_category

router = APIRouter()


def anonymize_category(category: VoteCategory, auth: AuthData) -> VoteListing:
    already_voted = None
    scores = [0] * len(category.options)

    for vote in category.votes:
        scores[vote.option] += 1
        if vote.uid == auth.sub:
            already_voted = vote.option

    return VoteListing(
        _id=category.id,
        category=category.category,
        options=category.options,
        scores=scores,
        already_voted=already_voted,
    )


@router.get(
    "/list",
    responses={
        **auth_responses,
    },
)
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


@router.get(
    "/{category_id}",
    responses={**auth_responses, 404: {"description": "Vote category not found"}},
)
async def get_category(
    category_id: int,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> VoteListing:
    """Get a single vote category"""
    category = await fetch_category(category_id, db)
    return anonymize_category(category, auth)


@router.get(
    "/{category_id}/votes",
    responses={**auth_responses, 404: {"description": "Vote category not found"}},
)
async def get_votes(
    category_id: int,
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> List[Vote]:
    """Get a single vote category"""
    category = await fetch_category(category_id, db)
    return category.votes
