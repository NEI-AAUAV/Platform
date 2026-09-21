from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, Annotated


class TeacherBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=100)]
    personal_page: Annotated[Optional[str], Field(max_length=50)]


class TeacherCreate(TeacherBase):
    pass


class TeacherUpdate(TeacherBase):
    pass


class TeacherInDB(TeacherBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
