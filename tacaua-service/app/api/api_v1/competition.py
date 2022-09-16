from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import deps
from app.schemas.competition import Competition, CompetitionCreate

router = APIRouter()


@router.post("/", status_code=201, response_model=Competition)
def create_competition(
    competition_in: CompetitionCreate, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=competition_in.modality_id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.competition.create(db=db, obj_in=competition_in)


@router.delete("/{id}", status_code=200, response_model=Competition)
def remove_competition(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    competition = crud.competition.get(db=db, id=id)
    if not competition:
        raise HTTPException(status_code=404, detail="Competition Not Found")
    return crud.competition.remove(db=db, id=id)
