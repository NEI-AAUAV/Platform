from pydantic import BaseModel

from typing import Optional
from typing_extensions import Annotated

class NotesSchoolyearBase(BaseModel):
    year_begin: int
    year_end: int

class NotesSchoolyearCreate(NotesSchoolyearBase):
    year_begin: int
    year_end: int

class NotesSchoolyearUpdate(NotesSchoolyearBase):
    year_begin: int
    year_end: int
    
class NotesSchoolyearInDB(NotesSchoolyearBase):
    id: int
    
    class Config:
        orm_mode = True