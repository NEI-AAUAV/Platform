from typing import Any, List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.schemas.partner import PartnerCreate, PartnerUpdate, PartnerInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[PartnerInDB])
def get_partners(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    return crud.partner.get_multi(db=db)


@router.get("/banner", status_code=200, response_model=PartnerInDB)
def get_partner_banner(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    return crud.partner.get_banner(db=db)