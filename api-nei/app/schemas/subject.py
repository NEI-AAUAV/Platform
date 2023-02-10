from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class SubjectBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class SubjectCreate(SubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class SubjectUpdate(SubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class SubjectInDB(SubjectBase):
    code: int
    
    class Config:
        orm_mode = True
