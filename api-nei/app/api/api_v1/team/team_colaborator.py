from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamColaboratorCreate, TeamColaboratorInDB, TeamColaboratorUpdate
from app.models.team_colaborator import TeamColaborator

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamColaboratorInDB])
def get_team_colaborators(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.team_colaborator.get_multi(db=db)


@router.post("/", status_code=201, response_model=TeamColaboratorInDB)
def create_team(
    *, team_colaborator_create_in: TeamColaboratorCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team_colaborator.create(db=db, obj_in=team_colaborator_create_in)


@router.put("/{id}", status_code=200, response_model=TeamColaboratorInDB)
def update_team_colaborator(
    *, team_colaborator_update_in: TeamColaboratorUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.team_colaborator.update(db=db, obj_in=team_colaborator_update_in, db_obj=db.get(TeamColaborator, id))
