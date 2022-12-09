from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

class NotesSubjectBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    
class NotesSubjectCreate(NotesSubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    
class NotesSubjectUpdate(NotesSubjectBase):
    name: Annotated[Optional[str], Field(max_length=60)]
    year: int
    semester: int
    short: Annotated[Optional[str], Field(max_length=5)]
    discontinued: int
    optional: int
    
class NotesSubjectInDB(NotesSubjectBase):
    paco_code: int
    
    class Config:
        orm_mode = True
    