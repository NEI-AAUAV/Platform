from fastapi import APIRouter, HTTPException, Security
from loguru import logger
from pydantic import BaseModel, NonNegativeInt
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure

from app.api.auth import AuthData, api_nei_auth
from app.core.db import DatabaseDep
from app.models.user import User
from app.models.vote import Vote, VoteCategory, VoteListing
from app.utils import NotFoundReCheck

from ._utils import fetch_category, anonymize_category

router = APIRouter()


class VoteForm(BaseModel):
    option: NonNegativeInt


@router.put("/{category_id}/cast")
async def cast_vote(
    category_id: int,
    form_data: VoteForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> VoteListing:
    """Casts a vote for a particular category"""
    user = await User.get_collection(db).find_one({"_id": auth.sub})

    if user is None:
        raise HTTPException(status_code=400, detail="An user must be created first")

    vote = Vote(uid=auth.sub, option=form_data.option)

    try:
        res = await VoteCategory.get_collection(db).find_one_and_update(
            {"_id": category_id},
            {"$push": {"votes": vote.dict()}},
            return_document=ReturnDocument.AFTER,
        )

        if res is None:
            raise NotFoundReCheck
    except (OperationFailure, NotFoundReCheck) as e:
        category = await fetch_category(category_id, db)

        if any(vote.uid == auth.sub for vote in category.votes):
            raise HTTPException(
                status_code=409, detail="Already voted in this category"
            )

        if vote.option >= len(category.options):
            raise HTTPException(status_code=400, detail="Not a valid option")

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    return anonymize_category(VoteCategory(**res), auth)
