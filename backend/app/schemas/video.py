from pydantic import BaseModel, Field


from .video_tag import VideoTagInDB
from datetime import datetime 
from typing import Optional
from typing_extensions import Annotated

class VideoBase(BaseModel):
    tag_id: list[int]
    ytld: Annotated[str, Field(max_length=255)]
    title: Annotated[str, Field(max_length=255)]
    subtitle: Annotated[Optional[str], Field(max_length=255)]
    image: Optional[str]
    created: datetime
    playlist: Optional[int]

class VideoInDB(VideoBase):
    id: int
    #tag: VideoTagInDB
    class Config:
        orm_mode = True

class VideoCreate(VideoBase):
    """Properties to receive via API on creation."""
    pass

class VideoUpdate(VideoBase):
    """Properties to receive via API on update."""
    ytld: Annotated[Optional[str], Field(max_length=255)]
    title: Annotated[Optional[str], Field(max_length=255)]
