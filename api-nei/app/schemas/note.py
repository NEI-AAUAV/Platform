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


class NoteBase(BaseModel):
    author_id: Optional[int]
    subject_id: int
    teacher_id: Optional[int]

    name: Annotated[str, StringConstraints(max_length=256)]
    location: str  ##AnyHttpUrl
    year: Optional[int]

    summary: Optional[int]
    tests: Optional[int]
    bibliography: Optional[int]
    slides: Optional[int]
    exercises: Optional[int]
    projects: Optional[int]
    notebook: Optional[int]

    created_at: datetime


class NoteInDB(NoteBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    author: Optional[AnonymousUserListing] = None
    subject: SubjectInDB
    teacher: Optional[TeacherInDB] = None
    contents: Optional[List[str]] = None
    size: Optional[int] = None
