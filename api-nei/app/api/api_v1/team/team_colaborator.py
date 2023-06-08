from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamColaboratorCreate, TeamColaboratorInDB, TeamColaboratorUpdate
from app.models.team import TeamColaborator

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamColaboratorInDB])
def get_team_colaborators(
    *, mandate: str | None = None,
    db: Session = Depends(deps.get_db), 
    _ = Depends(deps.long_cache),
) -> Any:
    """
    Return colaborator information.
    """
    print(mandate)
    return crud.team_colaborator.get_colaborators_by(db=db, mandate=mandate)


@router.post("/", status_code=201, response_model=TeamColaboratorInDB)
def create_team(
    *, team_colaborator_create_in: TeamColaboratorCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new colaborator row in the database.
    """
    return crud.team_colaborator.create(db=db, obj_in=team_colaborator_create_in)


@router.put("/{id}", status_code=200, response_model=TeamColaboratorInDB)
def update_team_colaborator(
    *, team_colaborator_update_in: TeamColaboratorUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a colaborator row in the database.
    """
    return crud.team_colaborator.update(db=db, obj_in=team_colaborator_update_in, db_obj=db.get(TeamColaborator, id))
