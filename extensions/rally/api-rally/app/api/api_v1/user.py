from typing import List

from fastapi import APIRouter, Depends
from pydantic import TypeAdapter
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.schemas.user import (
    UserUpdate,
    DetailedUser,
)

router = APIRouter()


@router.get("/")
async def get_users(
    *, db: Session = Depends(deps.get_db), _: DetailedUser = Depends(deps.get_admin)
) -> List[DetailedUser]:
    DetailUserListAdapter = TypeAdapter(List[DetailedUser])
    return DetailUserListAdapter.validate_python(crud.user.get_multi(db=db))


@router.get("/me")
async def get_me(*, user: DetailedUser = Depends(deps.get_participant)) -> DetailedUser:
    return user


@router.put("/{id}")
async def update_user(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: UserUpdate,
    _: DetailedUser = Depends(deps.get_admin)
) -> DetailedUser:
    return DetailedUser.model_validate(crud.user.update(db=db, id=id, obj_in=obj_in))
