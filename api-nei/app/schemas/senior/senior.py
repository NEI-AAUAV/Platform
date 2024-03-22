from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, List, Annotated

from app.utils import optional
from .senior_student import SeniorStudentInDB


class SeniorBase(BaseModel):
    year: int
    course: Annotated[str, Field(max_length=3)]
    image: Optional[Annotated[str, Field(max_length=256)]] = None


class SeniorCreate(SeniorBase):
    """Properties to receive via API on creation."""

    pass


@optional()
class SeniorUpdate(SeniorBase):
    """Properties to receive via API on update."""

    ...


class SeniorInDB(SeniorBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    students: List[SeniorStudentInDB]
