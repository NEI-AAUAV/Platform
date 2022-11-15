from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamCreate, TeamInDB, TeamUpdate
from app.models.team import Team

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamInDB])
def get_team(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.team.get_multi(db=db)

@router.get("/{mandato_id}", status_code=200, response_model=TeamInDB)
def get_team_by_mandato(
    *, db: Session = Depends(deps.get_db), mandato_id: int
) -> Any:
    """
    Return faina information.
    """
    return crud.team.get_team_by_mandato(db=db, mandato=mandato_id)


@router.post("/", status_code=201, response_model=TeamInDB)
def create_team(
    *, team_create_in: TeamCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.team.create(db=db, obj_in=team_create_in)

@router.put("/{id}", status_code=200, response_model=TeamInDB)
def update_team(
    *, team_update_in: TeamUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a faina row in the database.
    """
    return crud.faina.update(db=db, obj_in=team_update_in, db_obj=db.get(Team, id))
