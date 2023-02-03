from datetime import datetime
from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field

from .user import UserInDB
from .note_schoolyear import NoteSchoolyearInDB
from .note_teacher import NoteTeacherInDB
from .note_subject import NoteSubjectInDB
from .note_type import NoteTypeInDB


note_categories = {
    'summary', 'tests', 'bibliography', 'slides',
    'exercises', 'projects', 'notebook'
}


class NoteBase(BaseModel):
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


class NoteInDB(NoteBase):
    id: int
    subject: NoteSubjectInDB
    author: Optional[UserInDB]
    teacher: Optional[NoteTeacherInDB]
    school_year: Optional[NoteSchoolyearInDB]
    type: NoteTypeInDB

    class Config:
        orm_mode = True
