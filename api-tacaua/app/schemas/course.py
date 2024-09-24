from typing import List, Optional, Annotated

from pydantic import BaseModel, ConfigDict, AnyHttpUrl, StringConstraints

from app.utils import ValidateFromJson


class CourseBase(BaseModel):
    name: Annotated[str, StringConstraints(max_length=60)]
    short: Annotated[str, StringConstraints(max_length=16)]
    color: Optional[Annotated[str, StringConstraints(max_length=30)]] = None


class CourseCreate(CourseBase, ValidateFromJson):
    ...


class CourseUpdate(CourseBase, ValidateFromJson):
    name: Optional[Annotated[str, StringConstraints(max_length=60)]] = None
    short: Optional[Annotated[str, StringConstraints(max_length=16)]] = None
    color: Optional[Annotated[str, StringConstraints(max_length=30)]] = None


class Course(CourseBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    image: Optional[AnyHttpUrl]


class CourseList(BaseModel):
    courses: List[Course]
