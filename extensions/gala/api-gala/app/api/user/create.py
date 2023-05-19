from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo.errors import DuplicateKeyError
from typing import Optional

from app.models.user import User, Matriculation
from app.core.db import DatabaseDep
from app.api.auth import AuthData, api_nei_auth

router = APIRouter()


class UserCreateForm(BaseModel):
    email: str
    matriculation: Optional[Matriculation] = None


@router.post("/")
async def create_user(
    form_data: UserCreateForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> User:
    """Creates a new user"""
    user = User(
        _id=auth.sub,
        matriculation=form_data.matriculation,
        nmec=auth.nmec,
        email=form_data.email,
        name=auth.name,
    )

    try:
        await User.get_collection(db).insert_one(user.dict(by_alias=True))
    except DuplicateKeyError:
        raise HTTPException(status_code=409, detail="User already exists")

    return user
