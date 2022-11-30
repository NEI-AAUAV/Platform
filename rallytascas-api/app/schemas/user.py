from typing import Optional

from pydantic import BaseModel


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


class UserBase(BaseModel):
    team_id: Optional[int]
    name: str


class UserCreate(UserBase):
    username: Optional[str]
    staff_checkpoint_id: int = None
    is_admin: bool = False
    password: str


class UserUpdate(UserBase):
    name: Optional[str]
    username: Optional[str]
    staff_checkpoint_id: Optional[int]
    is_admin: Optional[bool]
    password: Optional[str]


class UserInDB(UserBase):
    id: int

    class Config:
        orm_mode = True


class AdminUserInDB(UserInDB):
    username: Optional[str]
    staff_checkpoint_id: int = None
    is_admin: bool = False
    hashed_password: str
