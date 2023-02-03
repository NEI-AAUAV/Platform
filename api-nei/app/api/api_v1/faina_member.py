from fastapi import APIRouter, Depends, HTTPException
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
    role = crud.faina_role.get(db=db, id=faina_member_create_in.role_id)
    if not role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    faina = crud.faina.get_faina(db=db, faina_id=faina_member_create_in.faina_id)
    if not faina:
        raise HTTPException(status_code=404, detail="Faina Not Found")
    user = crud.get(db=db, id=faina_member_create_in.member_id)
    if not user:
        raise HTTPException(status_code=404, detail="User Not Found")
    faina_member = crud.faina_member.get_faina_member(db=db, member_id=faina_member_create_in.member_id, faina_id=faina_member_create_in.faina_id, role_id=faina_member_create_in.role_id)
    if faina_member:
        raise HTTPException(status_code=400, detail="Faina Member Already Exists")
    return crud.faina_member.create(db=db, obj_in=faina_member_create_in)


@router.put("/{id}", status_code=200, response_model=FainaMemberInDB)
def update_faina_member(
    *, faina_member_update_in: FainaMemberUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    role = crud.faina_role.get(db=db, id=faina_member_update_in.role_id)
    if not role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    faina = crud.faina.get_faina(db=db, faina_id=faina_member_update_in.mfaina_idandate)
    if not faina:
        raise HTTPException(status_code=404, detail="Faina Not Found")
    user = crud.get(db=db, id=faina_member_update_in.member_id)
    if not user:
        raise HTTPException(status_code=404, detail="User Not Found")
    faina_member = crud.faina_member.get(db=db, id=id)
    if not faina_member:
        raise HTTPException(status_code=404, detail="Faina Member Not Found")
    return crud.faina_member.update(db=db, obj_in=faina_member_update_in, db_obj=db.get(FainaMember, id))
