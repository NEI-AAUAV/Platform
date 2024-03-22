from typing import Optional

from pydantic import BaseModel, ConfigDict


class UserBase(BaseModel):
    name: Optional[str] = None
    team_id: Optional[int] = None


class UserCreate(UserBase):
    id: int
    name: str
    staff_checkpoint_id: Optional[int] = None


class UserUpdate(UserBase):
    staff_checkpoint_id: Optional[int] = None


class ListingUser(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class DetailedUser(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    disabled: bool
    staff_checkpoint_id: Optional[int] = None
