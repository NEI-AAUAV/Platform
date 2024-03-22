from pydantic import BaseModel, Field, ConfigDict
from pydantic_extra_types.color import Color
from typing import Annotated


class VideoTagBase(BaseModel):
    name: Annotated[str, Field(max_length=256)]
    color: Color


class VideoTagInDB(VideoTagBase):
    model_config = ConfigDict(from_attributes=True)

    id: int


class VideoTagCreate(VideoTagBase):
    """Properties to receive via API on creation."""

    pass


class VideoTagUpdate(VideoTagBase):
    """Properties to receive via API on update."""

    pass
