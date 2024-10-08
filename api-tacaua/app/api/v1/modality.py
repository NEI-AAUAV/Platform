from typing import Any

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Request,
    Security,
)
from sqlalchemy.orm import Session

from app import crud
from app.api import deps, auth
from app.api.logger_router import ContextIncludedRoute
from app.schemas.modality import (
    Modality,
    ModalityCreate,
    ModalityUpdate,
    ModalityLazyList,
)

router = APIRouter(route_class=ContextIncludedRoute)

responses = {
    404: {"description": "Modality Not Found"},
}


@router.get("/", status_code=200, response_model=ModalityLazyList)
def get_multi_modality(
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
) -> Any:
    modalities = crud.modality.get_multi(db)
    return ModalityLazyList(modalities=modalities)


@router.post("/", status_code=201, response_model=Modality)
async def create_modality(
    modality_in: ModalityCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    modality = crud.modality.create(db, obj_in=modality_in)
    return modality


@router.get("/{id}", status_code=200, response_model=Modality, responses=responses)
def get_modality(
    id: int,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.shorter_cache),
) -> Any:
    modality = crud.modality.get(db, id=id)
    if not modality:
        raise HTTPException(status_code=404, detail="Modality Not Found")
    return crud.modality.get(db, id=id)


@router.put("/{id}", status_code=200, response_model=Modality, responses=responses)
async def update_modality(
    id: int,
    request: Request,
    modality_in: ModalityUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    modality = crud.modality.update(db, id=id, obj_in=modality_in)
    return modality


@router.delete("/{id}", status_code=200, response_model=Modality, responses=responses)
def remove_modality(
    id: int,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.modality.remove(db, id=id)
