from typing import Optional, List
from typing_extensions import Annotated
from enum import Enum
from datetime import datetime

from pydantic import BaseModel, Field

from .user import UserInDB


class CategoryEnum(str, Enum):
    EVENT = "Event"
    NEWS = "News"
    PARCERIA = "Parceria"


class NewsBase(BaseModel):
    header: Annotated[str, Field(max_length=256)]
    public: Optional[bool]
    title: Annotated[str, Field(max_length=256)]
    category: Annotated[str, Field(max_length=256)]
    content: Annotated[str, Field(max_length=20000)]
    created_at: datetime
    updated_at: Optional[datetime]
    author_id: int


class NewsInDB(NewsBase):
    id: int
    author: UserInDB

    class Config:
        orm_mode = True


class NewsCreate(NewsBase):
    """Properties to receive via API on creation."""

    pass


class NewsUpdate(NewsBase):
    """Properties to receive via API on update."""

    pass
    # id: int
    # changed_by: int
    # updated_at: datetime


class NewsCategories(BaseModel):
    data: List[str]
