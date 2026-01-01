"""
Course API endpoints.
"""

from typing import Optional

from fastapi import APIRouter, HTTPException, Query, Security
from pymongo.errors import DuplicateKeyError

from app.api import auth
from app.crud.crud_course import course as crud_course
from app.schemas.course import CourseCreate, CourseUpdate, CourseInDB, CourseList


router = APIRouter()


@router.get("/", status_code=200, response_model=CourseList)
def list_courses(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=1000),
    degree: Optional[str] = Query(default=None, description="Filter by degree (Licenciatura, Mestrado, Programa Doutoral)"),
    show_only: bool = Query(default=False, description="Only return courses with show=true"),
):
    """
    List all courses with optional filtering.
    
    - **degree**: Filter by degree type
    - **show_only**: Only return courses marked for display
    """
    query = {}
    if degree:
        query["degree"] = degree
    if show_only:
        query["show"] = True
    
    items = crud_course.get_multi(skip=skip, limit=limit, degree=degree, show_only=show_only)
    total = crud_course.count(query)
    
    return CourseList(items=items, total=total, skip=skip, limit=limit)


@router.get("/{course_id}", status_code=200, response_model=CourseInDB)
def get_course(course_id: int):
    """Get a specific course by ID."""
    course = crud_course.get(course_id)
    if not course:
        raise HTTPException(status_code=404, detail=f"Course {course_id} not found")
    return course


@router.post("/", status_code=201, response_model=CourseInDB)
def create_course(
    course_in: CourseCreate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create a new course. Requires MANAGER_FAMILY scope.
    
    Returns 409 Conflict if short code already exists.
    """
    # Check for duplicate short code
    if crud_course.short_exists(course_in.short):
        raise HTTPException(
            status_code=409, 
            detail=f"Course with short code '{course_in.short}' already exists"
        )
    
    try:
        return crud_course.create(obj_in=course_in)
    except DuplicateKeyError:
        raise HTTPException(
            status_code=409, 
            detail=f"Course with short code '{course_in.short}' already exists"
        )


@router.put("/{course_id}", status_code=200, response_model=CourseInDB)
def update_course(
    course_id: int,
    course_in: CourseUpdate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Update a course. Requires MANAGER_FAMILY scope.
    
    Returns 409 Conflict if new short code already exists on another course.
    """
    if not crud_course.exists(course_id):
        raise HTTPException(status_code=404, detail=f"Course {course_id} not found")
    
    # Check for duplicate short code (excluding current course)
    if course_in.short and crud_course.short_exists(course_in.short, exclude_id=course_id):
        raise HTTPException(
            status_code=409, 
            detail=f"Course with short code '{course_in.short}' already exists"
        )
    
    try:
        updated = crud_course.update(id=course_id, obj_in=course_in)
        if not updated:
            # Course may have been deleted between exists check and update
            raise HTTPException(status_code=404, detail=f"Course {course_id} not found")
        return updated
    except DuplicateKeyError:
        raise HTTPException(
            status_code=409, 
            detail=f"Course with short code '{course_in.short}' already exists"
        )


@router.delete("/{course_id}", status_code=204)
def delete_course(
    course_id: int,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """Delete a course. Requires MANAGER_FAMILY scope."""
    if not crud_course.delete(id=course_id):
        raise HTTPException(status_code=404, detail=f"Course {course_id} not found")
    return None
