from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, Optional, List

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.core.logging import logger
from app.schemas.team import TeamCreate, TeamUpdate, TeamInDB, Checkpoint

router = APIRouter()

@router.get("/me", status_code=200, response_model=Checkpoint)
def get_checkpoint(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return None