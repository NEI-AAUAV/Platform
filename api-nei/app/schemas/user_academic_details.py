from typing import List, Any
from datetime import datetime

from pydantic import BaseModel, Field

from app.utils import include

from .subject import SubjectInDB


@include(['created_at'])
class UserAcademicDetailsBase(BaseModel):
    user_id: int
    course_id: int
    curricular_year: int
    created_at: datetime = Field(default_factory=datetime.now)


class UserAcademicDetailsCreate(UserAcademicDetailsBase):
    pass


class UserAcademicDetailsUpdate(UserAcademicDetailsBase):
    pass


class UserAcademicDetailsInBD(UserAcademicDetailsBase):
    id: int
    subjects: List[SubjectInDB]

    class Config:
        orm = True
