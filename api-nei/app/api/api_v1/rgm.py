from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.rgm import RgmCategoryEnum, RgmInDB, RgmMandates

router = APIRouter()


@router.get("/", status_code=200, response_model=List[RgmInDB])
def get_rgm(
    category: str | None = None,
    mandate: str | None = None,
    db: Session = Depends(deps.get_db, scope="function"),
    _=Depends(deps.short_cache),
) -> Any:
    if category:
        try:
            # Accepts any case, as it always has.
            category = RgmCategoryEnum(category.upper()).value
        except ValueError:
            raise HTTPException(status_code=400, detail="Bad Request")
        return crud.rgm.get_by(db=db, category=category, mandate=mandate)
    return crud.rgm.get_by(db=db, mandate=mandate)


@router.get("/mandates", status_code=200, response_model=RgmMandates)
def get_rgm_mandates(
    db: Session = Depends(deps.get_db, scope="function"),
    _=Depends(deps.cms_cache),
) -> Any:
    data = crud.rgm.get_mandates(db=db)
    return {"data": data}
