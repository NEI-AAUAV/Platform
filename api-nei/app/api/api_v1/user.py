from fastapi import APIRouter, Depends, HTTPException, Query, Security
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.models import User
from app.schemas import UserCreate, UserUpdate, UserInDB
from app.schemas.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[UserInDB])
def get_users(
    *,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> Any:
    """ """
    return crud.user.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=UserInDB)
def get_user_by_id(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
) -> Any:
    """ """
    if not db.get(User, id):
        raise HTTPException(status_code=404, detail="Invalid User id")
    return crud.user.get(db=db, id=id)


@router.post("/", status_code=201, response_model=UserInDB)
def create_user(*, user_in: UserCreate, db: Session = Depends(deps.get_db)) -> dict:
    """
    Create a new user in the database.
    """
    return crud.user.create(db=db, obj_in=user_in)


@router.put("/{id}", status_code=200, response_model=UserInDB)
def update_user(
    *, user_in: UserUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a user in the database.
    """
    if not db.get(User, id):
        raise HTTPException(status_code=404, detail="Invalid User id")

    return crud.note.update(db=db, obj_in=user_in, db_obj=db.get(User, id))
