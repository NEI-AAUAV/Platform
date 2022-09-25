from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.modality import Modality, ModalityCreate, ModalityUpdate, ModalityLazyList

router = APIRouter()


@router.get("/", status_code=200, response_model=ModalityLazyList)
def get_multi_modality(
    db: Session = Depends(deps.get_db)
) -> Any:
    modalities = crud.modality.get_multi(db=db)
    return ModalityLazyList(modalities=modalities)


@router.post("/", status_code=201, response_model=Modality)
async def create_modality(
    modality_in: ModalityCreate = Form(..., alias='modality'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.create(db=db, obj_in=modality_in)
    try:
        modality = await crud.modality.update_image(
            db=db, db_obj=modality, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return modality


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
    request: Request,
    modality_in: ModalityUpdate = Form(..., alias='modality'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    modality = crud.modality.update(db=db, db_obj=modality, obj_in=modality_in)
    try:
        form = await request.form()
        if 'image' in form:
            modality = await crud.modality.update_image(
                db=db, db_obj=modality, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return modality


@router.delete("/{id}", status_code=200, response_model=Modality)
def remove_modality(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.remove(db=db, id=id)
