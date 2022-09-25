from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.team import Team, TeamCreate, TeamUpdate

router = APIRouter()


@router.post("/", status_code=201, response_model=Team)
async def create_team(
    team_in: TeamCreate = Form(..., alias='team'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    team = crud.team.create(db=db, obj_in=team_in)
    try:
        team = await crud.team.update_image(
            db=db, db_obj=team, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return team


@router.put("/{id}", status_code=200, response_model=Team)
async def update_team(
    id: int,
    request: Request,
    team_in: TeamUpdate = Form(..., alias='team'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise HTTPException(status_code=404, detail="Team Not Found")
    team = crud.team.update(db=db, db_obj=team, obj_in=team_in)
    try:
        form = await request.form()
        if 'image' in form:
            team = await crud.team.update_image(
                db=db, db_obj=team, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return team


@router.delete("/{id}", status_code=200, response_model=Team)
def remove_team(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise HTTPException(status_code=404, detail="Team Not Found")
    return crud.team.remove(db=db, id=id)
