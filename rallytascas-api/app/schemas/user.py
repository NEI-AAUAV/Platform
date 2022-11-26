from typing import Optional

from pydantic import BaseModel


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


class UserBase(BaseModel):
    team_id: Optional[int]
    username: str
    is_staff: bool = False
    is_admin: bool = False


class UserCreate(UserBase):
    password: str


class UserInDB(UserBase):
    id: int
    hashed_password: str # TODO: remove this

    class Config:
        orm_mode = True
