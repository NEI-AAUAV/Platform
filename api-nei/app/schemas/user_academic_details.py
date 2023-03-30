from typing import List, Any
from datetime import datetime

from pydantic import BaseModel, Field

from .subject import SubjectInDB


class UserAcademicDetailsBase(BaseModel):
    user_id: int
    course_id: int
    curricular_year: int
    created_at: datetime = Field(default_factory=datetime.now)
    subjects: List[SubjectInDB]


class UserAcademicDetailsCreate(UserAcademicDetailsBase):
    pass


class UserAcademicDetailsUpdate(UserAcademicDetailsBase):
    pass


class UserAcademicDetailsInBD(UserAcademicDetailsBase):
    id: int

    class Config:
        orm = True
