from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, Annotated

from app.schemas.user.user import AnonymousUserListing


class SeniorStudentBase(BaseModel):
    quote: Optional[Annotated[str, Field(max_length=280)]] = None
    image: Optional[Annotated[str, Field(max_length=256)]] = None


class SeniorStudentCreate(SeniorStudentBase):
    """Properties to receive via API on creation."""

    user_id: int
    senior_id: int
    image: Annotated[str, Field(max_length=256)]


class SeniorStudentUpdate(SeniorStudentBase):
    """Properties to receive via API on update."""

    ...


class SeniorStudentInDB(SeniorStudentBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    senior_id: int
    user: AnonymousUserListing
