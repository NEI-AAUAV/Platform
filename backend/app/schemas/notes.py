from datetime import datetime
from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

from .users import UsersInDB
from .notes_schoolyear import NotesSchoolyearInDB

from .notes_teachers import NotesTeachersInDB

from .notes_subject import NotesSubjectInDB


class NotesBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=255)]
    location: Annotated[Optional[str], Field(max_length=255)]
    subject_id: int
    author_id: int
    school_year_id: int
    teacher_id: int
    summary: int
    tests: int
    bibliography: int
    slides: int
    exercises: int
    projects: int
    notebook: int
    content: str
    created_at: datetime
    type_id: int
    size: int
    
class NotesCreate(NotesBase):
    pass


class NotesUpdate(NotesBase):
    pass


class NotesInDB(NotesBase):
    id: int
    subject: NotesSubjectInDB
    author: UsersInDB
    teacher: NotesTeachersInDB
    school_year: NotesSchoolyearInDB
    class Config:
        orm_mode = True
