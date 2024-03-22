from typing import List

from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import FainaMemberCreate, FainaMemberInDB, FainaMemberUpdate
from app.schemas.user.user import ScopeEnum


router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaMemberInDB])
def get_faina_member(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    """
    Return faina information.
    """
    return crud.faina_member.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=FainaMemberInDB)
def get_faina_member_by_id(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    """
    Return faina information.
    """
    member = crud.faina_member.get(db=db, id=id)
    if member is None:
        raise HTTPException(status_code=404, detail="Faina Member Not Found")
    return member


@router.post("/", status_code=201, response_model=FainaMemberInDB)
def create_faina_member(
    *,
    faina_member_create_in: FainaMemberCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Create a new faina row in the database.
    """
    return crud.faina_member.create(db=db, obj_in=faina_member_create_in)


@router.put("/{id}", status_code=200, response_model=FainaMemberInDB)
def update_faina_member(
    *,
    id: int,
    faina_member_update_in: FainaMemberUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Update a faina row in the database.
    """
    member = crud.faina_member.update_locked(
        db=db,
        id=id,
        obj_in=faina_member_update_in,
    )
    if member is None:
        raise HTTPException(status_code=404, detail="Faina Member Not Found")
    return member
