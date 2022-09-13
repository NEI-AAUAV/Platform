from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import deps
from app.schemas.modality import Modality, ModalityCreate, ModalityList

router = APIRouter()


@router.get("/", status_code=200, response_model=ModalityList)
def get_multi_modality(
    db: Session = Depends(deps.get_db)
) -> Any:
    # get modalities without nested competition and teams
    modalities = crud.modality.get_multi_noload(db=db)
    return ModalityList(modalities=modalities)


@router.get("/{id}", status_code=200, response_model=Modality)
def get_modality(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    # get modalities with nested competition and teams
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.get(db=db, id=id)


@router.post("/", status_code=200, response_model=Modality)
def create_modality(
    modality_in: ModalityCreate, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.modality.create(db=db, obj_in=modality_in)


@router.delete("/{id}", status_code=200, response_model=Modality)
def remove_modality(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.remove(db=db, id=id)
