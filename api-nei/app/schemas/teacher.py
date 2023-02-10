from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

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
    id: int
    
    class Config:
        orm_mode = True