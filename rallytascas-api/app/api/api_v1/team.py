from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, List, Optional

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.core.logging import logger
from app.schemas.user import UserInDB
from app.schemas.team import TeamCreate, TeamUpdate, TeamInDB, TeamMeInDB, StaffScoresTeamUpdate, StaffCardsTeamUpdate

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamInDB])
def get_teams(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.team.get_multi(db)


@router.put("/{id}/checkpoint", status_code=201, response_model=TeamInDB)
def add_checkpoint(
    *, db: Session = Depends(deps.get_db),
    id: int,
    obj_in: StaffScoresTeamUpdate,
    staff_user: UserInDB = Depends(deps.get_staff)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.add_checkpoint(
        db=db, team=team, checkpoint_id=staff_user.staff_checkpoint_id, obj_in=obj_in)


@router.put("/{id}/cards", status_code=201, response_model=TeamInDB)
def activate_cards(
    *, db: Session = Depends(deps.get_db),
    id: int,
    obj_in: StaffCardsTeamUpdate,
    staff_user: UserInDB = Depends(deps.get_staff)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.activate_cards(
        db=db, team=team, checkpoint_id=staff_user.staff_checkpoint_id, obj_in=obj_in)


@router.get("/me", status_code=200, response_model=TeamMeInDB)
def get_own_team(
    db: Session = Depends(deps.get_db),
    curr_user: UserInDB = Depends(deps.get_participant)
) -> Any:
    return crud.team.get(db=db, id=curr_user.team_id)


@router.post("/", status_code=201, response_model=TeamInDB)
def create_team(
    *,
    db: Session = Depends(deps.get_db),
    team_in: TeamCreate,
    admin_user: UserInDB = Depends(deps.get_admin)
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
    admin_user: UserInDB = Depends(deps.get_admin)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.update(db=db, id=id, obj_in=team_in)