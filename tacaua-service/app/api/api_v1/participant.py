from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.participant import Participant, ParticipantCreate, ParticipantUpdate

router = APIRouter()



@router.post("/", status_code=201, response_model=Participant)
async def create_participant(
    request: Request,
    participant_in: ParticipantCreate,
    db: Session = Depends(deps.get_db)
) -> Any:
    return crud.participant.create(db=db, obj_in=participant_in)


@router.put("/{id}", status_code=200, response_model=Participant)
async def update_participant(
    id: int,
    participant_in: ParticipantUpdate,
    db: Session = Depends(deps.get_db)
) -> Any:
    participant = crud.participant.get(db=db, id=id)
    if not participant:
        raise HTTPException(status_code=404, detail="Participant Not Found")
    return crud.participant.update(db=db, db_obj=participant, obj_in=participant_in)


@router.delete("/{id}", status_code=200, response_model=Participant)
def remove_participant(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    participant = crud.participant.get(db=db, id=id)
    if not participant:
        raise HTTPException(status_code=404, detail="Participant Not Found")
    return crud.participant.remove(db=db, id=id)
