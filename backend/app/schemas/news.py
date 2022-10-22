from typing import Optional, List

from pydantic import BaseModel, Field
from datetime import datetime

from enum import Enum
from typing_extensions import Annotated
#from .users import UserInDB
class StatusEnum(int, Enum):
     ACTIVE : 1
     INACTIVE : 0


class CategoryEnum(str, Enum):
     EVENT = "Event"
     NEWS = "News"
     PARCERIA = "Parceria"

class NewsBase(BaseModel):
     header: Annotated[str, Field(max_length=255)]
     status: StatusEnum
     title: Annotated[str, Field(max_length=255)]
     category: Annotated[str, Field(max_length=255)]
     content: Annotated[str, Field(max_length=20000)]
     publish_by: int
     created_at: datetime
     last_change_at: Optional[datetime]
     changed_by: Optional[int]
     author_id: int

class NewsInDB(NewsBase):
     id: int
     #publisher: UserInDB
     #author: UserInDB
     #editor: Optional[UserInDB]

     class Config:
          orm_mode = True



class NewsCreate(NewsBase):
     """Properties to receive via API on creation."""
     pass


class NewsUpdate(NewsBase):
     """Properties to receive via API on update."""
     pass
     #id: int
     #changed_by: int
     #last_change_at: datetime


class NewsCategories(BaseModel):
     data: List[str]


