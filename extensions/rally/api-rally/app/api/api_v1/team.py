from typing import List
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends

from app import crud
from app.api import deps
from app.schemas.user import AdminUser, DetailedUser
from app.schemas.team import (
    TeamCreate,
    ListingTeam,
    TeamUpdate,
    DetailedTeam,
    TeamScoresUpdate,
    TeamCardsUpdate,
)

from ._deps import get_checkpoint_id

router = APIRouter()


@router.get("/", status_code=200)
def get_teams(*, db: Session = Depends(deps.get_db)) -> List[ListingTeam]:
    teams = crud.team.get_multi(db)
    return crud.team.convert_to_listing(teams)


@router.put("/{id}/checkpoint", status_code=201)
def add_checkpoint(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: TeamScoresUpdate,
    staff_user: DetailedUser = Depends(deps.get_admin_or_staff)
) -> DetailedTeam:
    checkpoint_id = get_checkpoint_id(staff_user, obj_in)
    team_db = crud.team.add_checkpoint(
        db=db,
        id=id,
        checkpoint_id=checkpoint_id,
        obj_in=obj_in,
    )
    return DetailedTeam.model_validate(team_db)


@router.put("/{id}/cards", status_code=201)
def activate_cards(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: TeamCardsUpdate,
    staff_user: DetailedUser = Depends(deps.get_admin_or_staff)
) -> DetailedTeam:
    checkpoint_id = get_checkpoint_id(staff_user, obj_in)
    team_db = crud.team.activate_cards(
        db, id=id, checkpoint_id=checkpoint_id, obj_in=obj_in
    )
    return DetailedTeam.model_validate(team_db)


@router.get("/me", status_code=200)
def get_own_team(
    db: Session = Depends(deps.get_db),
    curr_user: DetailedUser = Depends(deps.get_participant),
) -> DetailedTeam:
    return DetailedTeam.model_validate(crud.team.get(db=db, id=curr_user.team_id))


@router.post("/", status_code=201)
def create_team(
    *,
    db: Session = Depends(deps.get_db),
    team_in: TeamCreate,
    _: AdminUser = Depends(deps.get_admin)
) -> DetailedTeam:
    return DetailedTeam.model_validate(crud.team.create(db=db, obj_in=team_in))


@router.put("/{id}", status_code=200, response_model=DetailedTeam)
def update_team(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    team_in: TeamUpdate,
    _: AdminUser = Depends(deps.get_admin)
) -> DetailedTeam:
    return DetailedTeam.model_validate(crud.team.update(db=db, id=id, obj_in=team_in))
