from typing import List
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException

from app import crud
from app.api import deps
from app.models.team import Team
from app.schemas.user import AdminUser, StaffUser, DetailedUser
from app.schemas.team import (
    AdminCheckPointSelect,
    TeamCreate,
    ListingTeam,
    TeamUpdate,
    DetailedTeam,
    TeamScoresUpdate,
    TeamCardsUpdate,
)

router = APIRouter()


@router.get("/", status_code=200)
def get_teams(*, db: Session = Depends(deps.get_db)) -> List[ListingTeam]:
    teams = crud.team.get_multi(db)

    min_time_scores = crud.team.calculate_min_time_scores(teams)

    def build_listing(team: Team) -> ListingTeam:
        listing = ListingTeam(
            id=team.id,
            name=team.name,
            total=team.total,
            classification=team.classification,
        )

        last_checkpoint = len(team.times) - 1 if len(team.times) > 0 else None
        if last_checkpoint is not None:
            listing.last_checkpoint_time = team.times[last_checkpoint]
            listing.last_checkpoint_score = crud.team.calculate_checkpoint_score(
                last_checkpoint, team=team, min_time_scores=min_time_scores
            )

        return listing

    return list(map(build_listing, teams))


def _checkpoint_id(user: StaffUser, form: AdminCheckPointSelect) -> int:
    if (
        not user.is_admin
        and form.checkpoint_id is not None
        and form.checkpoint_id != user.staff_checkpoint_id
    ):
        raise HTTPException(
            status_code=401, detail="Only admins can specify the checkpoint"
        )

    return (
        form.checkpoint_id
        if form.checkpoint_id is not None
        else user.staff_checkpoint_id
    )


@router.put("/{id}/checkpoint", status_code=201)
def add_checkpoint(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: TeamScoresUpdate,
    staff_user: StaffUser = Depends(deps.get_admin_or_staff)
) -> DetailedTeam:
    checkpoint_id = _checkpoint_id(staff_user, obj_in)
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
    staff_user: StaffUser = Depends(deps.get_admin_or_staff)
) -> DetailedTeam:
    checkpoint_id = _checkpoint_id(staff_user, obj_in)
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
    admin_user: DetailedUser = Depends(deps.get_admin)
) -> DetailedTeam:
    return DetailedTeam.model_validate(crud.team.create(db=db, obj_in=team_in))


@router.put("/{id}", status_code=200, response_model=DetailedTeam)
def update_team(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    team_in: TeamUpdate,
    admin_user: AdminUser = Depends(deps.get_admin)
) -> DetailedTeam:
    return DetailedTeam.model_validate(crud.team.update(db=db, id=id, obj_in=team_in))
