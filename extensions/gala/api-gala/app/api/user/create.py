from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo.errors import DuplicateKeyError
from typing import Optional

from app.models.user import User, Matriculation
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.api.limits.util import fetch_limits

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

    if registrations >= limits.maxRegistrations:
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
