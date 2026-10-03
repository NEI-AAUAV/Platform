from datetime import datetime
from typing import Annotated, Optional, List

from pydantic import BaseModel, ConfigDict, StringConstraints

from .teacher import TeacherInDB
from .subject import SubjectInDB
from app.schemas.user.user import AnonymousUserListing


note_categories = {
    "summary",
    "tests",
    "bibliography",
    "slides",
    "exercises",
    "projects",
    "notebook",
}


class NoteAuthorInDB(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    surname: str


class NoteBase(BaseModel):
    author_id: Optional[int] = None
    subject_id: int
    teacher_id: Optional[int] = None

    name: Annotated[str, StringConstraints(max_length=256)]
    location: str  ##AnyHttpUrl
    year: Optional[int] = None

    summary: Optional[int] = None
    tests: Optional[int] = None
    bibliography: Optional[int] = None
    slides: Optional[int] = None
    exercises: Optional[int] = None
    projects: Optional[int] = None
    notebook: Optional[int] = None

    created_at: datetime


class NoteInDB(NoteBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    author: Optional[AnonymousUserListing] = None
    note_author: Optional[NoteAuthorInDB] = None
    subject: SubjectInDB
    teacher: Optional[TeacherInDB] = None
    contents: Optional[List[str]] = None
    size: Optional[int] = None
