from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

from.users import UsersInDB

class NotesThanksBase(BaseModel):
    author_id: int
    notes_personal_page: Annotated[Optional[str], Field(max_length=255)]
    
class NotesThanksCreate(NotesThanksBase):
    author_id: int
    notes_personal_page: Annotated[Optional[str], Field(max_length=255)]

class NotesThanksUpdate(NotesThanksBase):
    author_id: int
    notes_personal_page: Annotated[Optional[str], Field(max_length=255)]
    
class NotesThanksInDB(NotesThanksBase):
    id: int

    class Config:
        orm_mode = True