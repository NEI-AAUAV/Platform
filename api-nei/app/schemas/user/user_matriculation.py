from typing import List, Any
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.utils import include

from app.schemas.subject import SubjectInDB


@include(["created_at"])
class UserMatriculationBase(BaseModel):
    user_id: int
    course_id: int
    curricular_year: int
    created_at: datetime = Field(default_factory=datetime.now)


class UserMatriculationCreate(UserMatriculationBase):
    pass


class UserMatriculationUpdate(UserMatriculationBase):
    pass


class UserMatriculationInBD(UserMatriculationBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    subjects: List[SubjectInDB]
