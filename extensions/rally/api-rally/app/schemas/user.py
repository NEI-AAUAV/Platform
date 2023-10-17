from typing import Literal, Optional

from pydantic import BaseModel, ConfigDict


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str


class UserBase(BaseModel):
    name: Optional[str] = None
    team_id: Optional[int] = None


class UserCreate(UserBase):
    name: str
    username: Optional[str] = None
    staff_checkpoint_id: Optional[int] = None
    is_admin: bool = False
    password: str


class UserUpdate(UserBase):
    username: Optional[str] = None
    staff_checkpoint_id: Optional[int] = None
    is_admin: Optional[bool] = None
    password: Optional[str] = None


class ListingUser(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class DetailedUser(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class StaffUserInDB(DetailedUser):
    is_admin: bool
    staff_checkpoint_id: int


class AdminUserInDB(StaffUserInDB):
    name: str
    is_admin: Literal[True]
    username: Optional[str] = None
    hashed_password: str
