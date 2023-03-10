from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.rgm import RgmCreate, RgmUpdate, RgmInDB

router = APIRouter()


@router.get("/{category}", status_code=200, response_model=List[RgmInDB])
def get_rgm(
    category: str, db: Session = Depends(deps.get_db),
) -> Any:
    valid_categories = ["PAO", "RAC", "ATAS"]
    if category.upper() in valid_categories:
        return crud.rgm.get_by(db=db, category=category)
    else:
        raise HTTPException(status_code=400, detail="Bad Request")
