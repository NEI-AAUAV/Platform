from fastapi import APIRouter, Depends, HTTPException, Security, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.exception import NotFoundException
from app.api import auth, deps
from app.core.logging import logger
from app.schemas.team import Team, TeamCreate, TeamUpdate

router = APIRouter()

responses = {
    404: {'description': "Team Not Found"},
}


@router.post("/", status_code=201, response_model=Team,
             responses={404: {'description': "Course Not Found"}})
async def create_team(
    team_in: TeamCreate = Form(..., alias='team'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    course = crud.course.get(db=db, id=team_in.course_id)
    if not course:
        raise NotFoundException(detail="Course Not Found")
    team = crud.team.create(db, obj_in=team_in)
    team = await crud.team.update_image(
        db=db, db_obj=team, image=image)
    return team


@router.put("/{id}", status_code=200, response_model=Team,
            responses=responses)
async def update_team(
    id: int,
    request: Request,
    team_in: TeamUpdate = Form(..., alias='team'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    team = crud.team.update(db, id=id, obj_in=team_in)
    form = await request.form()
    if 'image' in form:
        team = await crud.team.update_image(
            db=db, db_obj=team, image=image)
    return team


@router.delete("/{id}", status_code=200, response_model=Team,
               responses=responses)
def remove_team(
    id: int, db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.team.remove(db, id=id)
