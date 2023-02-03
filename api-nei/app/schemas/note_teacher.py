from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

class NoteTeacherBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]
    
class NoteTeacherCreate(NoteTeacherBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]

class NoteTeacherUpdate(NoteTeacherBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]
    
class NoteTeacherInDB(NoteTeacherBase):
    id: int
    
    class Config:
        orm_mode = True