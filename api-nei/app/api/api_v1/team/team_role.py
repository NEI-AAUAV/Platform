from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import TeamRoleCreate, TeamRoleInDB, TeamRoleUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamRoleInDB])
def get_team_roles(
    *, db: Session = Depends(deps.get_db), _=Depends(deps.long_cache)
) -> Any:
    """
    Return team roles information.
    """
    return crud.team_role.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=TeamRoleInDB)
def get_team_role_by_id(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
    id: int,
) -> Any:
    """
    Return specific team role information.
    """
    role = crud.team_role.get(db=db, id=id)
    if role is None:
        raise HTTPException(status_code=404, detail="Team role not found")
    return role


@router.post("/", status_code=201, response_model=TeamRoleInDB)
def create_team_role(
    *,
    team_role_create_in: TeamRoleCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team_role.create(db=db, obj_in=team_role_create_in)


@router.put("/{id}", status_code=200, response_model=TeamRoleInDB)
def update_team_role(
    *,
    id: int,
    team_role_update_in: TeamRoleUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Update a faina row in the database.
    """
    role = crud.team_role.update_locked(db=db, id=id, obj_in=team_role_update_in)
    if role is None:
        raise HTTPException(status_code=404, detail="Team role not found")
    return role
