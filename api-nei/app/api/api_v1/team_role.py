from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamRoleCreate, TeamRoleInDB, TeamRoleUpdate
from app.models.team_role import TeamRole

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamRoleInDB])
def get_team_roles(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.team_role.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=TeamRoleInDB)
def get_team_role_by_id(
    *, db: Session = Depends(deps.get_db), id: int
) -> Any:
    """
    Return faina information.
    """
    return crud.team_role.get(db=db, id=id)


@router.post("/", status_code=201, response_model=TeamRoleInDB)
def create_team_role(
    *, team_role_create_in: TeamRoleCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team_role.create(db=db, obj_in=team_role_create_in)


@router.put("/{id}", status_code=200, response_model=TeamRoleInDB)
def update_team_role(
    *, team_role_update_in: TeamRoleUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.team_role.update(db=db, obj_in=team_role_update_in, db_obj=db.get(TeamRole, id))
