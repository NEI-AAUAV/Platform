from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.rgm import RgmCreate, RgmUpdate, RgmInDB, RgmMandates

router = APIRouter()


@router.get("/", status_code=200, response_model=List[RgmInDB])
def get_rgm(
    category: str | None = None,
    mandate: str | None = None,
    db: Session = Depends(deps.get_db),
    _ = Depends(deps.short_cache),
) -> Any:
    valid_categories = ["PAO", "RAC", "ATA"]
    if category:
        if (category := category.upper()) in valid_categories:
            return crud.rgm.get_by(db=db, category=category, mandate=mandate)
        raise HTTPException(status_code=400, detail="Bad Request")
    return crud.rgm.get_by(db=db, mandate=mandate)


@router.get("/mandates", status_code=200, response_model=RgmMandates)
def get_rgm_mandates(
    db: Session = Depends(deps.get_db),
    _ = Depends(deps.long_cache),
) -> Any:
    data = crud.rgm.get_mandates(db=db)
    return {"data": data}
