from pydantic import BaseModel, Field

from typing import Optional, List
from typing_extensions import Annotated

from .senior_student import SeniorStudentInDB


class SeniorBase(BaseModel):
    year: int
    course: Annotated[str, Field(max_length=3)]
    image: Annotated[Optional[str], Field(max_length=256)]


class SeniorCreate(SeniorBase):
    """Properties to receive via API on creation."""
    pass


class SeniorUpdate(SeniorBase):
    """Properties to receive via API on update."""
    year: int
    course: Annotated[str, Field(max_length=3)]


class SeniorInDB(SeniorBase):
    """Properties properties stored in DB."""
    year: int
    course: Annotated[str, Field(max_length=3)]
    students: List[SeniorStudentInDB]

    class Config:
        orm_mode = True
