from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import NotesCreate, NotesUpdate, NotesInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[Any])
def get_notes(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    """
    return crud.notes.get_multi(db=db, limit=5)
