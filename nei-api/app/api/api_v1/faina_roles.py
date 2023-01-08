from app.models import faina_roles
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import FainaRolesCreate, FainaRolesInDB, FainaRolesUpdate
from app.models.faina_roles import FainaRoles

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaRolesInDB])
def get_faina_roles(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.faina_roles.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=FainaRolesInDB)
def get_faina_roles_by_id(
    *, db: Session = Depends(deps.get_db), id: int
) -> Any:
    """
    Return faina information.
    """
    faina_role = crud.faina_roles.get(db=db, id=id)
    if not faina_role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return faina_role


@router.post("/", status_code=201, response_model=FainaRolesInDB)
def create_faina_roles(
    *, faina_roles_create_in: FainaRolesCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.faina_roles.create(db=db, obj_in=faina_roles_create_in)


@router.put("/{id}", status_code=200, response_model=FainaRolesInDB)
def update_faina_roles(
    *, faina_roles_update_in: FainaRolesUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    faina_role = crud.faina_roles.get(db=db, id=id)
    if not faina_role:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return crud.faina_roles.update(db=db, obj_in=faina_roles_update_in, db_obj=db.get(FainaRoles, id))
