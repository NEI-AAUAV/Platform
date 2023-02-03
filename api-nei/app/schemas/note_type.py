from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class NoteTypeBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external: int
    

class NoteTypeCreate(NoteTypeBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external: int


class NoteTypeUpdate(NoteTypeBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external: int
    

class NoteTypeInDB(NoteTypeBase):
    id: int
    
    class Config:
        orm_mode = True
