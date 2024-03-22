from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import FainaRoleCreate, FainaRoleInDB, FainaRoleUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaRoleInDB])
def get_faina_role(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    """
    Return faina information.
    """
    return crud.faina_role.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=FainaRoleInDB)
def get_faina_role_by_id(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    _=Depends(deps.long_cache),
):
    """
    Return faina information.
    """
    faina_role = crud.faina_role.get(db=db, id=id)
    if faina_role is None:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return faina_role


@router.post("/", status_code=201, response_model=FainaRoleInDB)
def create_faina_role(
    *,
    faina_role_create_in: FainaRoleCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Create a new faina row in the database.
    """
    return crud.faina_role.create(db=db, obj_in=faina_role_create_in)


@router.put("/{id}", status_code=200, response_model=FainaRoleInDB)
def update_faina_role(
    *,
    id: int,
    faina_role_update_in: FainaRoleUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Update a faina row in the database.
    """
    faina_role = crud.faina_role.update_locked(
        db=db, id=id, obj_in=faina_role_update_in
    )
    if faina_role is None:
        raise HTTPException(status_code=404, detail="Faina Role Not Found")
    return faina_role
