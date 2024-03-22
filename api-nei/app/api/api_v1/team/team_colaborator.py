# TODO(capucho): The team colaborator seems to be a simpler version of the team
#                member this extra duplication doesn't seem worth the space
#                savings (if any) and merging them would allow to track the
#                roles of the collaborators which might be interesting.
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import (
    TeamColaboratorCreate,
    TeamColaboratorInDB,
    TeamColaboratorUpdate,
)
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TeamColaboratorInDB])
def get_team_colaborators(
    *,
    mandate: Optional[str] = None,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    """
    Return colaborator information.
    """
    return crud.team_colaborator.get_colaborators_by(db=db, mandate=mandate)


@router.post("/", status_code=201, response_model=TeamColaboratorInDB)
def create_team(
    *,
    team_colaborator_create_in: TeamColaboratorCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Create a new colaborator row in the database.
    """
    return crud.team_colaborator.create(db=db, obj_in=team_colaborator_create_in)


@router.put("/{id}/{mandate:path}", status_code=200, response_model=TeamColaboratorInDB)
def update_team_colaborator(
    *,
    id: int,
    mandate: str,
    team_colaborator_update_in: TeamColaboratorUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Update a colaborator row in the database.
    """
    colab = crud.team_colaborator.update_locked(
        db=db, id=(id, mandate), obj_in=team_colaborator_update_in
    )
    if colab is None:
        raise HTTPException(status_code=404, detail="Team colaborator not found")
    return colab
