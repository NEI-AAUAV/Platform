from typing import Optional, Annotated

from pydantic import BaseModel, Field, ConfigDict


class SubjectBase(BaseModel):
    code: int
    curricular_year: Optional[int] = None
    name: Annotated[Optional[str], Field(max_length=60)] = None
    short: Annotated[Optional[str], Field(max_length=5)] = None
    public: Optional[bool] = None
    link: Annotated[Optional[str], Field(max_length=2048)] = None


class SubjectCreate(SubjectBase):
    pass


class SubjectUpdate(SubjectBase):
    pass


class SubjectInDB(SubjectBase):
    model_config = ConfigDict(from_attributes=True)
