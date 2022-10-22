from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import FainaMemberCreate, FainaMemberInDB, FainaMemberUpdate
from app.models.faina_member import FainaMember

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaMemberInDB])
def get_faina_member(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.faina_member.get_multi(db=db)

@router.get("/{id}", status_code=200, response_model=FainaMemberInDB)
def get_faina_member_by_id(
    *, db: Session = Depends(deps.get_db), id: int
) -> Any:
    """
    Return faina information.
    """
    return crud.faina_member.get(db=db, id=id)

@router.post("/", status_code=201, response_model=FainaMemberInDB)
def create_faina_member(
    *, faina_member_create_in: FainaMemberCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.faina_member.create(db=db, obj_in=faina_member_create_in)

@router.put("/{id}", status_code=200, response_model=FainaMemberInDB)
def update_faina_member(
    *, faina_member_update_in: FainaMemberUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.faina_member.update(db=db, obj_in=faina_member_update_in, db_obj=db.get(FainaMember, id))
