from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, Annotated


class TeacherBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]


class TeacherCreate(TeacherBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]


class TeacherUpdate(TeacherBase):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]


class TeacherInDB(TeacherBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
