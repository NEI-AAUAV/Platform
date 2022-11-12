from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

class NotesTeachersBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]
    
class NotesTeachersCreate(NotesTeachersBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]

class NotesTeachersUpdate(NotesTeachersBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]
    
class NotesTeachersInDB(NotesTeachersBase):
    id: int
    
    class Config:
        orm_mode = True