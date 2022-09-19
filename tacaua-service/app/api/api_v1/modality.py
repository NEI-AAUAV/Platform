from io import BytesIO
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.modality import Modality, ModalityCreate, ModalityUpdate, LazyModalityList

router = APIRouter()


@router.get("/", status_code=200, response_model=LazyModalityList)
def get_multi_modality(
    db: Session = Depends(deps.get_db)
) -> Any:
    modalities = crud.modality.get_multi(db=db)
    logger.debug([m.__dict__ for m in modalities])
    return LazyModalityList(modalities=modalities)


@router.post("/", status_code=201, response_model=Modality)
async def create_modality(
    modality_in: ModalityCreate = Depends(ModalityCreate.as_form),
    image: UploadFile = File(...),
    db: Session = Depends(deps.get_db)
) -> Any:
    try:
        return await crud.modality.create(db=db, obj_in=modality_in,
                                          image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)


@router.get("/{id}", status_code=200, response_model=Modality)
def get_modality(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.get(db=db, id=id)


@router.put("/{id}", status_code=200, response_model=Modality)
async def update_modality(
    id: int,
    modality_in: ModalityUpdate = Depends(ModalityUpdate.as_form),
    image: UploadFile = File(...),
    db: Session = Depends(deps.get_db)
) -> dict:
    """
    Update a tacaUA game in the database.
    """
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    try:
        return await crud.modality.update(db=db, db_obj=modality,
                                          obj_in=modality_in, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)


@router.delete("/{id}", status_code=200, response_model=Modality)
def remove_modality(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.remove(db=db, id=id)
