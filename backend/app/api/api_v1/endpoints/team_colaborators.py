from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamColaboratorsCreate, TeamColaboratorsInDB, TeamColaboratorsUpdate
from app.models.team_colaborators import TeamColaborators

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamColaboratorsInDB])
def get_team_colaborators(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.team_colaborators.get_multi(db=db)


@router.post("/", status_code=201, response_model=TeamColaboratorsInDB)
def create_team(
    *, team_colaborators_create_in: TeamColaboratorsCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team_colaborators.create(db=db, obj_in=team_colaborators_create_in)

@router.put("/{id}", status_code=200, response_model=TeamColaboratorsInDB)
def update_team_colaborators(
    *, team_colaborators_update_in: TeamColaboratorsUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.team_colaborators.update(db=db, obj_in=team_colaborators_update_in, db_obj=db.get(TeamColaborators, id))
