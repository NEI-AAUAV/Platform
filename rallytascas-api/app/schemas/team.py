from typing import Optional, List, Any, Union
from datetime import datetime

from pydantic import BaseModel

from .user import UserInDB


class TeamBase(BaseModel):
    name: str


class TeamCreate(TeamBase):
    ...


class TeamUpdate(TeamBase):
    name: Optional[str]
    scores: Optional[List[int]]
    times: Optional[List[datetime]]


class TeamInDB(TeamBase):
    id: int
    scores: List[int]
    times: List[datetime]
    classification: int
    members: List[UserInDB]

    class Config:
        orm_mode = True


class TeamMeInDB(TeamInDB):
    card1: bool
    card2: bool
    card3: bool


class StaffTeamUpdate(BaseModel):
    score: Optional[int]
    card1: Optional[bool]
    card2: Optional[bool]
    card3: Optional[bool]
