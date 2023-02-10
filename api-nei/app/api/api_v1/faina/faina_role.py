from app.models import faina_role
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import FainaRoleCreate, FainaRoleInDB, FainaRoleUpdate
from app.models.faina_role import FainaRole

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaRoleInDB])
def get_faina_role(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.faina_role.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=FainaRoleInDB)
def get_faina_role_by_id(
    *, db: Session = Depends(deps.get_db), id: int
) -> Any:
    """
    Return faina information.
    """
    faina_role = crud.faina_role.get(db=db, id=id)
    if not faina_role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return faina_role


@router.post("/", status_code=201, response_model=FainaRoleInDB)
def create_faina_role(
    *, faina_role_create_in: FainaRoleCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.faina_role.create(db=db, obj_in=faina_role_create_in)


@router.put("/{id}", status_code=200, response_model=FainaRoleInDB)
def update_faina_role(
    *, faina_role_update_in: FainaRoleUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    faina_role = crud.faina_role.get(db=db, id=id)
    if not faina_role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return crud.faina_role.update(db=db, obj_in=faina_role_update_in, db_obj=db.get(FainaRole, id))
