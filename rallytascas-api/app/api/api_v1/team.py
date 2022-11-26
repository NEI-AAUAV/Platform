from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.core.logging import logger
from app.schemas.user import UserInDB
from app.schemas.team import TeamCreate, TeamUpdate, TeamInDB, Checkpoint

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamInDB])
def get_teams(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.team.get_multi(db)


@router.put("/{id}/checkpoint", status_code=201, response_model=TeamInDB)
def add_checkpoint(
    id: int,
    checkpoint: Checkpoint,
    db: Session = Depends(deps.get_db)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.add_checkpoint(db=db, team=team, checkpoint=checkpoint)


@router.get("/me", status_code=200, response_model=TeamInDB)
def get_own_team(
    db: Session = Depends(deps.get_db), curr_user: UserInDB = Depends(deps.get_current_active_user)
) -> Any:
    return crud.team.get(db=db, id=curr_user.team_id)


@router.post("/", status_code=201, response_model=TeamInDB)
def create_team(
    *,
    db: Session = Depends(deps.get_db),
    team_in: TeamCreate,
) -> Any:
    team = crud.team.get_multi(db)
    # check if team name already exists
    for t in team:
        if t.name == team_in.name:
            raise HTTPException(
                status_code=400, detail="Team name already exists")
    return crud.team.create(db=db, obj_in=team_in)


@router.put("/{id}", status_code=200, response_model=TeamInDB)
def update_team(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    team_in: TeamUpdate,
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.update(db=db, id=id, obj_in=team_in)
