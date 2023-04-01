from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class SubjectBase(BaseModel):
    code: int
    name: Annotated[Optional[str], Field(max_length=60)]
    curricular_year: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    course_id: int

class SubjectCreate(SubjectBase):
    pass

class SubjectUpdate(SubjectBase):
    pass

class SubjectInDB(SubjectBase):
    code: int

    class Config:
        orm_mode = True
