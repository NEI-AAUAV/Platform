from pydantic import BaseModel, Field


from .video_tag import VideoTagInDB
from datetime import datetime 
from typing import Optional, List
from typing_extensions import Annotated

class VideoBase(BaseModel):
    youtube_id: Annotated[str, Field(max_length=255)]
    title: Annotated[str, Field(max_length=255)]
    subtitle: Annotated[Optional[str], Field(max_length=255)]
    image: Optional[str]
    created_at: datetime
    playlist: Optional[int]

class VideoInDB(VideoBase):
    id: int
    tags: List[VideoTagInDB]
    class Config:
        orm_mode = True

class VideoCreate(VideoBase):
    """Properties to receive via API on creation."""
    pass

class VideoUpdate(VideoBase):
    """Properties to receive via API on update."""
    youtube_id: Annotated[Optional[str], Field(max_length=255)]
    title: Annotated[Optional[str], Field(max_length=255)]
