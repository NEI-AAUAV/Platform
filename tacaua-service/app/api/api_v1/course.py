from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.course import Course, CourseCreate, CourseUpdate, CourseList

router = APIRouter()


@router.get("/", status_code=200, response_model=CourseList)
def get_multi_course(
    db: Session = Depends(deps.get_db)
) -> Any:
    courses = crud.course.get_multi(db=db)
    return CourseList(courses=courses)


@router.post("/", status_code=201, response_model=Course)
async def create_course(
    course_in: CourseCreate = Form(..., alias='course'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    course = crud.course.create(db=db, obj_in=course_in)
    try:
        course = await crud.course.update_image(
            db=db, db_obj=course, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return course


@router.get("/{id}", status_code=200, response_model=Course)
def get_course(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    course = crud.course.get(db=db, id=id)
    if not course:
        raise HTTPException(status_code=404, detail="Course Not Found")
    return crud.course.get(db=db, id=id)


@router.put("/{id}", status_code=200, response_model=Course)
async def update_course(
    id: int,
    request: Request,
    course_in: CourseUpdate = Form(..., alias='course'),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(deps.get_db)
) -> Any:
    course = crud.course.get(db=db, id=id)
    if not course:
        raise HTTPException(status_code=404, detail="Course Not Found")
    course = crud.course.update(db=db, db_obj=course, obj_in=course_in)
    try:
        form = await request.form()
        if 'image' in form:
            course = await crud.course.update_image(
                db=db, db_obj=course, image=image)
    except Exception as err:
        raise HTTPException(status_code=400, detail=err)
    return course


@router.delete("/{id}", status_code=200, response_model=Course)
def remove_course(
    id: int, db: Session = Depends(deps.get_db)
) -> Any:
    course = crud.course.get(db=db, id=id)
    if not course:
        raise HTTPException(status_code=404, detail="Course Not Found")
    return crud.course.remove(db=db, id=id)
