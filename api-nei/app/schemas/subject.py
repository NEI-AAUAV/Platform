from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class SubjectBase(BaseModel):
    code: int
    curricular_year: Optional[int]
    name: Annotated[Optional[str], Field(max_length=60)]
    short: Annotated[Optional[str], Field(max_length=5)]
    public: Optional[bool]
    link: Annotated[Optional[str], Field(max_length=2048)]


class SubjectCreate(SubjectBase):
    pass


class SubjectUpdate(SubjectBase):
    pass


class SubjectInDB(SubjectBase):
    class Config:
        orm_mode = True
