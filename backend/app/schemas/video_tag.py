from pydantic import BaseModel, Field
from pydantic.color import Color
from typing import Optional
from typing_extensions import Annotated

class VideoTagBase(BaseModel):
    name: Annotated[str, Field(max_length=255)]
    color: Color


class VideoTagInDB(VideoTagBase):
    id: int
    class Config:
        orm_mode = True

class VideoTagCreate(VideoTagBase):
    """Properties to receive via API on creation."""
    pass

class VideoTagUpdate(VideoTagBase):
    """Properties to receive via API on update."""
    pass