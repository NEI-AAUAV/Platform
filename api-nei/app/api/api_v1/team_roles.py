from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamRolesCreate, TeamRolesInDB, TeamRolesUpdate
from app.models.team_roles import TeamRoles

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamRolesInDB])
def get_team_roles(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.team_roles.get_multi(db=db)


@router.get("/{id}", status_code=200, response_model=TeamRolesInDB)
def get_team_roles_by_id(
    *, db: Session = Depends(deps.get_db), id: int
) -> Any:
    """
    Return faina information.
    """
    return crud.team_roles.get(db=db, id=id)


@router.post("/", status_code=201, response_model=TeamRolesInDB)
def create_team_roles(
    *, team_roles_create_in: TeamRolesCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team_roles.create(db=db, obj_in=team_roles_create_in)


@router.put("/{id}", status_code=200, response_model=TeamRolesInDB)
def update_team_roles(
    *, team_roles_update_in: TeamRolesUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.team_roles.update(db=db, obj_in=team_roles_update_in, db_obj=db.get(TeamRoles, id))
