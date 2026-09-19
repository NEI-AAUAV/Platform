from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import TeamMemberCreate, TeamMemberInDB, TeamMemberUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


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


@router.delete("/{id}", status_code=204)
def delete_team_member(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    res = crud.team_member.delete(db=db, id=id)
    if res is None:
        raise HTTPException(status_code=404, detail="Team member not found")
