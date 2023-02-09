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


class UserUABase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=256)]
    full_name: Annotated[Optional[str], Field(max_length=256)]
    uu_email: Annotated[Optional[str], Field(max_length=256)]
    uu_iupi: Annotated[Optional[str], Field(max_length=256)]
    curriculo: Optional[str]
    linkedin: Optional[str]
    git: Optional[str]
    permission: Optional[PermissionEnum]
    created_at: datetime
