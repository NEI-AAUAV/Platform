from typing import List, Optional

from pydantic import BaseModel, constr, AnyHttpUrl

from app.utils import validate_to_json


class CourseBase(BaseModel):
    name: constr(max_length=60)
    initials: constr(max_length=16)
    color: constr(max_length=30) = "white"


@validate_to_json
class CourseCreate(CourseBase):
    pass


@validate_to_json
class CourseUpdate(CourseBase):
    name: Optional[constr(max_length=60)]
    initials: Optional[constr(max_length=16)]
    color: Optional[constr(max_length=30)]


class Course(CourseBase):
    id: int
    image: Optional[AnyHttpUrl]

    class Config:
        orm_mode = True


class CourseList(BaseModel):
    courses: List[Course]