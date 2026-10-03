from typing import Optional, Annotated

from pydantic import BaseModel, Field, ConfigDict


class SubjectBase(BaseModel):
    code: int
    curricular_year: Optional[int] = None
    name: Annotated[Optional[str], Field(max_length=60)]
    short: Annotated[Optional[str], Field(max_length=5)]
    public: Optional[bool] = None
    link: Annotated[Optional[str], Field(max_length=2048)]


class SubjectCreate(SubjectBase):
    pass


class SubjectUpdate(SubjectBase):
    pass


class SubjectInDB(SubjectBase):
    model_config = ConfigDict(from_attributes=True)
