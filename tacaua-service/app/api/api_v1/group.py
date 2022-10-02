from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.group import Group, GroupCreate, GroupUpdate

router = APIRouter()

responses = {
    404: {'description': "Group Not Found"},
}


@router.post("/", status_code=201, response_model=Group)
async def create_group(
    group_in: GroupCreate,
    db: Session = Depends(deps.get_db)
) -> Any:
    return crud.group.create(db, obj_in=group_in)


@router.put("/{id}", status_code=200, response_model=Group,
            responses={404: {'description': "Group Not Found / "
                             "Exchange Group Not Found / "
                             "Team In Modality Not Found"}})
async def update_group(
    id: int,
    group_in: GroupUpdate,
    db: Session = Depends(deps.get_db)
) -> Any:
    return crud.group.update(db, id=id, obj_in=group_in)


@router.delete("/{id}", status_code=200, response_model=Group,
               responses=responses)
def remove_group(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.group.remove(db, id=id)
