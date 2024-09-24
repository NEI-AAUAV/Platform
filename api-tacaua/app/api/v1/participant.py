from fastapi import APIRouter, Depends, Security
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import auth, deps
from app.api.logger_router import ContextIncludedRoute
from app.schemas.participant import Participant, ParticipantCreate, ParticipantUpdate

router = APIRouter(route_class=ContextIncludedRoute)

responses = {
    404: {"description": "Participant Not Found"},
}


@router.post("/", status_code=201, response_model=Participant)
async def create_participant(
    participant_in: ParticipantCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.participant.create(db, obj_in=participant_in)


@router.put("/{id}", status_code=200, response_model=Participant)
async def update_participant(
    id: int,
    participant_in: ParticipantUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.participant.update(db, id=id, obj_in=participant_in)


@router.delete("/{id}", status_code=200, response_model=Participant)
def remove_participant(
    id: int,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.participant.remove(db, id=id)
