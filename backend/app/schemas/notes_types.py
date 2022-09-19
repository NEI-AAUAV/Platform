from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

class NotesTypesBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external = int
    
class NotesTypesCreate(NotesTypesBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external = int

class NotesTypesUpdate(NotesTypesBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=40)]
    download_caption: Annotated[Optional[str], Field(max_length=40)]
    icon_display: Annotated[Optional[str], Field(max_length=40)]
    icon_download: Annotated[Optional[str], Field(max_length=40)]
    external = int
    
class NotesTypesInDB(NotesTypesBase):
    id: int
    
    class Config:
        orm_mode = True