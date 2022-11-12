from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.models.users import Users
from app.schemas import UsersCreate, UsersUpdate, UsersInDB

router = APIRouter()

@router.get("/", status_code=200, response_model=List[UsersInDB])
def get_users(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    """
    return crud.users.get_multi(db=db)

@router.get("/{user_id}", status_code=200, response_model=UsersInDB)
def get_user_by_id(
    *,user_id: int, db: Session = Depends(deps.get_db),
) -> Any:
    """
    """
    if not db.get(Users, user_id):
        raise HTTPException(status_code=404, detail="Invalid User id")
    return crud.users.get(db=db, id=user_id)

@router.post("/", status_code=201, response_model=UsersInDB)
def create_user(
    *, user_in: UsersCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new user in the database.
    """
    return crud.users.create(db=db, obj_in=user_in)

@router.put("/{user_id}", status_code=200, response_model=UsersInDB)
def update_user(
    *, user_in: UsersUpdate, db: Session = Depends(deps.get_db), user_id: int
) -> dict:
    """
    Update a user in the database.
    """
    if not db.get(Users, user_id):
        raise HTTPException(status_code=404, detail="Invalid User id")
    
    return crud.notes.update(db=db, obj_in=user_in, db_obj=db.get(Users, user_id))