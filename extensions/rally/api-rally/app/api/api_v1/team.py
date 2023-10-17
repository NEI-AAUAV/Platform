from fastapi import APIRouter, Depends, HTTPException
from pydantic import TypeAdapter
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.user import AdminUserInDB, StaffUserInDB, UserInDB
from app.schemas.team import (
    TeamCreate,
    TeamListing,
    TeamUpdate,
    TeamInDB,
    TeamMeInDB,
    StaffScoresTeamUpdate,
    StaffCardsTeamUpdate,
)

router = APIRouter()


@router.get("/", status_code=200)
def get_teams(*, db: Session = Depends(deps.get_db)) -> List[TeamListing]:
    teams = crud.team.get_multi(db)
    TeamListAdapter = TypeAdapter(List[TeamListing])
    return TeamListAdapter.validate_python(teams)


@router.put("/{id}/checkpoint", status_code=201, response_model=TeamMeInDB)
def add_checkpoint(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: StaffScoresTeamUpdate,
    staff_user: StaffUserInDB = Depends(deps.get_admin_or_staff)
) -> Any:
    if (
        not staff_user.is_admin
        and obj_in.checkpoint_id is not None
        and obj_in.checkpoint_id != staff_user.staff_checkpoint_id
    ):
        raise HTTPException(
            status_code=401, detail="Only admins can specify the checkpoint"
        )

    checkpoint_id = (
        obj_in.checkpoint_id
        if obj_in.checkpoint_id is not None
        else staff_user.staff_checkpoint_id
    )
    return crud.team.add_checkpoint(
        db=db,
        id=id,
        checkpoint_id=checkpoint_id,
        obj_in=obj_in,
    )


@router.put("/{id}/cards", status_code=201, response_model=TeamMeInDB)
def activate_cards(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: StaffCardsTeamUpdate,
    staff_user: StaffUserInDB = Depends(deps.get_staff)
) -> Any:
    return crud.team.activate_cards(
        db, id=id, checkpoint_id=staff_user.staff_checkpoint_id, obj_in=obj_in
    )


@router.get("/me", status_code=200, response_model=TeamMeInDB)
def get_own_team(
    db: Session = Depends(deps.get_db),
    curr_user: UserInDB = Depends(deps.get_participant),
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
            raise HTTPException(status_code=400, detail="Team name already exists")
    return crud.team.create(db=db, obj_in=team_in)


@router.put("/{id}", status_code=200, response_model=TeamInDB)
def update_team(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    team_in: TeamUpdate,
    admin_user: AdminUserInDB = Depends(deps.get_admin)
) -> Any:
    return crud.team.update(db=db, id=id, obj_in=team_in)
