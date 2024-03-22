from pydantic import BaseModel, Field, ConfigDict


from .video_tag import VideoTagInDB
from datetime import datetime
from typing import Optional, List, Annotated


class VideoBase(BaseModel):
    youtube_id: Annotated[str, Field(max_length=256)]
    title: Annotated[str, Field(max_length=256)]
    subtitle: Annotated[Optional[str], Field(max_length=256)]
    image: Optional[str]
    created_at: datetime
    playlist: Optional[int]


class VideoInDB(VideoBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    tags: List[VideoTagInDB]


class VideoCreate(VideoBase):
    """Properties to receive via API on creation."""

    pass


class VideoUpdate(VideoBase):
    """Properties to receive via API on update."""

    youtube_id: Annotated[Optional[str], Field(max_length=256)]
    title: Annotated[Optional[str], Field(max_length=256)]
