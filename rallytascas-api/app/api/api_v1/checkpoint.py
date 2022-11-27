from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, Optional, List

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.core.logging import logger
from app.schemas.checkpoint import CheckPointInDB

router = APIRouter()

@router.get("/me", status_code=200, response_model=CheckPointInDB)
def get_checkpoint(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return None