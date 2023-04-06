from datetime import datetime
from typing import Optional

from pydantic import BaseModel, AnyHttpUrl, constr

from .user import UserInDB
from .teacher import TeacherInDB
from .subject import SubjectInDB


note_categories = {
    'summary', 'tests', 'bibliography', 'slides',
    'exercises', 'projects', 'notebook'
}


class NoteBase(BaseModel):
    author_id: Optional[int]
    subject_id: int
    teacher_id: Optional[int]

    name: constr(max_length=256)
    location: str ##AnyHttpUrl
    year: Optional[int]

    summary: Optional[int]
    tests: Optional[int]
    bibliography: Optional[int]
    slides: Optional[int]
    exercises: Optional[int]
    projects: Optional[int]
    notebook: Optional[int]

    content: Optional[str]
    created_at: datetime
    size: Optional[int]


class NoteInDB(NoteBase):
    id: int
    author: Optional[UserInDB]
    subject: SubjectInDB
    teacher: Optional[TeacherInDB]

    class Config:
        orm_mode = True
