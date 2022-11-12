from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

class NotesSchoolyearBase(BaseModel):
    yearBegin: int
    yearEnd: int

class NotesSchoolyearCreate(NotesSchoolyearBase):
    yearBegin: int
    yearEnd: int

class NotesSchoolyearUpdate(NotesSchoolyearBase):
    yearBegin: int
    yearEnd: int
    
class NotesSchoolyearInDB(NotesSchoolyearBase):
    id: int
    
    class Config:
        orm_mode = True