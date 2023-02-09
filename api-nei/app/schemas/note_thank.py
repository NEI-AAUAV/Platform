from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field

from .user import UserInDB


class NoteThankBase(BaseModel):
    author_id: int
    note_personal_page: Annotated[Optional[str], Field(max_length=256)]
    

class NoteThankCreate(NoteThankBase):
    author_id: int
    note_personal_page: Annotated[Optional[str], Field(max_length=256)]


class NoteThankUpdate(NoteThankBase):
    author_id: int
    note_personal_page: Annotated[Optional[str], Field(max_length=256)]
    

class NoteThankInDB(NoteThankBase):
    id: int
    author: UserInDB

    class Config:
        orm_mode = True
