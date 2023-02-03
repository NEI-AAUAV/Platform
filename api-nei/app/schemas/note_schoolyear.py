from pydantic import BaseModel


class NoteSchoolyearBase(BaseModel):
    year_begin: int
    year_end: int


class NoteSchoolyearCreate(NoteSchoolyearBase):
    year_begin: int
    year_end: int


class NoteSchoolyearUpdate(NoteSchoolyearBase):
    year_begin: int
    year_end: int
    

class NoteSchoolyearInDB(NoteSchoolyearBase):
    id: int
    
    class Config:
        orm_mode = True
