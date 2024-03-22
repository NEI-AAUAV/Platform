from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import TeamMemberCreate, TeamMemberInDB, TeamMemberUpdate, TeamMandates
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/mandates", status_code=200, response_model=TeamMandates)
def get_team_members_mandates(
    db: Session = Depends(deps.get_db), _=Depends(deps.long_cache)
):
    """
    Return all mandates.
    """
    data = crud.team_member.get_team_mandates(db=db)
    return {"data": data}


@router.get("/", status_code=200, response_model=List[TeamMemberInDB])
def get_team_members(
    mandate: str, db: Session = Depends(deps.get_db), _=Depends(deps.long_cache)
):
    return crud.team_member.get_team_by_mandate(db=db, mandate=mandate)


@router.post("/", status_code=201, response_model=TeamMemberInDB)
def create_team_member(
    *,
    team_create_in: TeamMemberCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    return crud.team_member.create(db=db, obj_in=team_create_in)


@router.put("/{id}", status_code=200, response_model=TeamMemberInDB)
def update_team_member(
    *,
    team_update_in: TeamMemberUpdate,
    db: Session = Depends(deps.get_db),
    id: int,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    res = crud.team_member.update_locked(db=db, id=id, obj_in=team_update_in)
    if res is None:
        raise HTTPException(status_code=404, detail="Team member not found")
    return res
