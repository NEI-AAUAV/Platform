from typing import Any, Optional

from fastapi import APIRouter, Depends, HTTPException, Security, UploadFile, File, Request, Form
from sqlalchemy.orm import Session

from app import crud
from app.api import auth, deps
from app.core.logging import logger
from app.schemas.course import Course, CourseCreate, CourseUpdate, CourseList


router = APIRouter()

responses = {
    404: {'description': "Course Not Found"},
}


@router.get("/", status_code=200, response_model=CourseList)
def get_multi_course(
    db: Session = Depends(deps.get_db)
) -> Any:
    courses = crud.course.get_multi(db)
    return CourseList(courses=courses)


@router.post("/", status_code=201, response_model=Course,
             responses=responses)
async def create_course(
    course_in: CourseCreate = Form(..., alias='course'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    course = crud.course.create(db, obj_in=course_in)
    course = await crud.course.update_image(
        db=db, db_obj=course, image=image)
    return course


@router.get("/{id}", status_code=200, response_model=Course,
            responses=responses)
def get_course(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.course.get(db, id=id)


@router.put("/{id}", status_code=200, response_model=Course,
            responses=responses)
async def update_course(
    id: int,
    request: Request,
    course_in: CourseUpdate = Form(..., alias='course'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    course = crud.course.update(db, id=id, obj_in=course_in)
    form = await request.form()
    if 'image' in form:
        course = await crud.course.update_image(
            db=db, db_obj=course, image=image)
    return course


@router.delete("/{id}", status_code=200, response_model=Course,
               responses=responses)
def remove_course(
    id: int, db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.course.remove(db, id=id)
