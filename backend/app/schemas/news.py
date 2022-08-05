from typing import Optional
from backend.app.db.base_class import Base
from pydantic import BaseModel

from enum import Enum
from typing_extensions import Annotated

class StatusEnum(int, Enum):
     ACTIVE : 1
     INACTIVE : 0

class NewsBase(BaseModel):
     ...