from typing import Any

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.schemas.competition import Competition, CompetitionCreate, CompetitionUpdate


router = APIRouter()

responses = {
    404: {'description': "Competition Not Found"},
}


@router.post("/", status_code=201, response_model=Competition,
    responses={404: {'description': "Modality Not Found"}})
def create_competition(
    competition_in: CompetitionCreate, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=competition_in.modality_id)
    if not modality:
        raise NotFoundException(detail="Modality Not Found")
    return crud.competition.create(db=db, obj_in=competition_in)


@router.put("/{id}", status_code=200, response_model=Competition,
            responses=responses)
def update_competition(
    id: int, competition_in: CompetitionUpdate, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.competition.update(db, id=id, obj_in=competition_in)


@router.delete("/{id}", status_code=200, response_model=Competition,
               responses=responses)
def remove_competition(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.competition.remove(db, id=id)