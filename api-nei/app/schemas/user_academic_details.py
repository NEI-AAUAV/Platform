from typing import List, Any
from datetime import datetime

from pydantic import BaseModel

from .subject import SubjectInDB


class UserAcademicDetailsInBD(BaseModel):
    id: int
    user_id: int
    course_id: int
    curricular_year: int
    created_at: datetime
    subjects: List[SubjectInDB]

    class Config:
        orm = True
