from datetime import datetime
from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

from .users import UsersInDB
from .notes_schoolyear import NotesSchoolyearInDB
from .notes_teachers import NotesTeachersInDB
from .notes_subject import NotesSubjectInDB
from .notes_types import NotesTypesInDB


notes_categories = {
    'summary', 'tests', 'bibliography', 'slides',
    'exercises', 'projects', 'notebook'
}


class NotesBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=255)]
    location: Annotated[Optional[str], Field(max_length=2048)]
    subject_id: int
    author_id: Optional[int]
    school_year_id: Optional[int]
    teacher_id: Optional[int]
    summary: Optional[int]
    tests: Optional[int]
    bibliography: Optional[int]
    slides: Optional[int]
    exercises: Optional[int]
    projects: Optional[int]
    notebook: Optional[int]
    content: Optional[str]
    created_at: datetime
    type_id: int
    size: Optional[int]


class NotesInDB(NotesBase):
    id: int
    subject: NotesSubjectInDB
    author: Optional[UsersInDB]
    teacher: Optional[NotesTeachersInDB]
    school_year: Optional[NotesSchoolyearInDB]
    type: NotesTypesInDB

    class Config:
        orm_mode = True
