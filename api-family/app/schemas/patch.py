from typing import Optional, List
from datetime import datetime
from bson.objectid import ObjectId

from pydantic import BaseModel, Field, validator

from app.utils import to_camel_case
from .user import UserCreate, UserAdminUpdate, UserInDB


class MessageBase(BaseModel):
    text: str


class MessageCreate(MessageBase):
    _sent_at: datetime = Field(
        default_factory=datetime.now, alias='sent_at')

    class Config:
        underscore_attrs_are_private = True


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
    _created_at: datetime = Field(
        default_factory=datetime.now, alias='created_at')
    _updated_at: datetime = Field(
        default_factory=datetime.now, alias='updated_at')

    class Config:
        underscore_attrs_are_private = True


class PatchUpdate(PatchBase):
    users: List[UserAdminUpdate]
    _updated_at: datetime = Field(
        default_factory=datetime.now, alias='updated_at')

    class Config:
        underscore_attrs_are_private = True


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
