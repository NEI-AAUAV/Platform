from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo.errors import DuplicateKeyError
from typing import Optional

from app.models.user import User, Matriculation
from app.models.table import Table
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.api.limits.util import fetch_limits

import app.queries.table as table_queries

router = APIRouter()


class UserCreateForm(BaseModel):
    nmec: int
    matriculation: Optional[Matriculation] = None


@router.post(
    "/",
    responses={
        **auth_responses,
        409: {"description": "Registrations are closed or user already exists"},
    },
)
async def create_user(
    form_data: UserCreateForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> User:
    """Creates a new user"""
    limits = await fetch_limits(db)
    registrations = await User.get_collection(db).count_documents({})
    companions = (
        await Table.get_collection(db)
        .aggregate(
            [
                {
                    "$project": {
                        "count": {"$sum": table_queries.num_confirmed_companions},
                    }
                },
                {
                    "$group": {
                        "_id": None,
                        "total": {"$sum": "$count"},
                    },
                },
            ]
        )
        .to_list(None)
    )
    companions = companions[0]["total"] if companions else 0

    # FIXME: this is bad, it assumes that users do not change the current number of companions
    # the fix would be to require the number of companions on the inscription
    # but the requirements needed were incomplete at the time of development
    if registrations + companions >= limits.maxRegistrations:
        raise HTTPException(status_code=409, detail="Registrations are closed")

    user = User(
        _id=auth.sub,
        matriculation=form_data.matriculation,
        nmec=form_data.nmec,
        email=auth.email,
        name=f"{auth.name} {auth.surname}",
    )

    try:
        await User.get_collection(db).insert_one(user.dict(by_alias=True))
    except DuplicateKeyError:
        raise HTTPException(status_code=409, detail="User already exists")

    return user
