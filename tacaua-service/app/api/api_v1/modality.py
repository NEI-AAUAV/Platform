from io import BytesIO
from urllib import request
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Request
from sqlalchemy.orm import Session
from typing import Any, Optional

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


from fastapi import Form
@router.put("/{id}", status_code=200, response_model=Modality)
async def update_modality(
    id: int,
    request: Request,
    modality_in: ModalityUpdate = Form(..., alias="modality"),
    image: UploadFile = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    form = await request.form()
    logger.debug(form._dict)
    modality_in = ModalityUpdate(**form._dict)
    logger.debug(modality_in.dict(exclude_unset=True))

    modality = crud.modality.get(db=db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    try:
        return await crud.modality.update(db=db, db_obj=modality,
                                          obj_in=modality_in)
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
