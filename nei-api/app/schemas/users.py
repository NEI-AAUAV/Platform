from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field

from enum import Enum
from typing_extensions import Annotated


class PermissionEnum(str, Enum):
    DEFAULT = 'DEFAULT'
    FAINA = 'FAINA'
    HELPER = 'HELPER'
    COLABORATOR = 'COLABORATOR'
    MANAGER = 'MANAGER'
    ADMIN = 'ADMIN'


class UsersBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=255)]
    full_name: Annotated[Optional[str], Field(max_length=255)]
    uu_email: Annotated[Optional[str], Field(max_length=255)]
    uu_iupi: Annotated[Optional[str], Field(max_length=255)]
    curriculo: Optional[str]
    linkedin: Optional[str]
    git: Optional[str]
    permission: Optional[PermissionEnum]
    created_at: datetime

class UsersCreate(UsersBase):
    """Properties to receive via API on create."""
    name: Annotated[Optional[str], Field(max_length=255)]
    full_name: Annotated[Optional[str], Field(max_length=255)]
    uu_email: Annotated[Optional[str], Field(max_length=255)]
    uu_iupi: Annotated[Optional[str], Field(max_length=255)]
    curriculo: Optional[str]
    linkedin: Optional[str]
    git: Optional[str]
    created_at: datetime
    
    
class UsersUpdate(UsersBase):
    """Properties to receive via API on create."""
    name: Annotated[Optional[str], Field(max_length=255)]
    full_name: Annotated[Optional[str], Field(max_length=255)]
    uu_email: Annotated[Optional[str], Field(max_length=255)]
    uu_iupi: Annotated[Optional[str], Field(max_length=255)]
    curriculo: Optional[str]
    linkedin: Optional[str]
    git: Optional[str]

  
class UsersInDB(UsersBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
    