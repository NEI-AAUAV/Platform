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