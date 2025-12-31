from typing import Optional, List
from datetime import datetime
from bson.objectid import ObjectId

from pydantic import BaseModel, Field, validator

from app.utils import to_camel_case
from .user import UserCreate, UserUpdate, UserInDB


class MessageBase(BaseModel):
    text: str


class MessageCreate(MessageBase):
    # TODO: do not forget
    # sent_at: datetime = Field(default_factory=datetime.now)
    pass


class MessageInDB(MessageBase):
    from_id: int            # Reference to a NEI Service user ID
    date: datetime

    class Config:
        orm_mode = True
        alias_generator = to_camel_case


class PatchBase(BaseModel):
    approved: Optional[bool]
    unread: bool = False


class PatchCreate(PatchBase):
    users: List[UserCreate]
    # TODO: do not forget
    # created_at: datetime = Field(default_factory=datetime.now)
    # updated_at: datetime = Field(default_factory=datetime.now)


class PatchUpdate(PatchBase):
    users: List[UserUpdate]
    # TODO: do not forget
    # updated_at: datetime = Field(default_factory=datetime.now)


class PatchInDB(PatchBase):
    # id: ObjectId = Field(alias='_id') FIXME:
    patcher_id: int
    users: List[UserInDB]
    discussion: List[MessageInDB] = []
    created_at: datetime
    updated_at: datetime

    # @validator('id')
    # def is_id_valid(cls, v):
    #     if not ObjectId.is_valid(id):
    #         raise ValueError("Invalid ID")
    #     return v

    class Config:
        orm_mode = True
        allow_population_by_field_name = True
        arbitrary_types_allowed = True
        alias_generator = to_camel_case
        json_encoders = {ObjectId: str}


class PatchLazyList(BaseModel):
    # TODO:
    ...
