from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class NoteSubjectBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class NoteSubjectCreate(NoteSubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class NoteSubjectUpdate(NoteSubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    

class NoteSubjectInDB(NoteSubjectBase):
    paco_code: int
    
    class Config:
        orm_mode = True
