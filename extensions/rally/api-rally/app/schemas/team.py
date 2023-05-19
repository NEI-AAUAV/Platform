from typing import Optional, List, Any, Union
from datetime import datetime

from pydantic import BaseModel, conint

from .user import UserInDB


class TeamBase(BaseModel):
    name: str


class TeamCreate(TeamBase):
    ...


class TeamUpdate(TeamBase):
    name: Optional[str]
    question_scores: Optional[List[bool]]
    time_scores: Optional[List[int]]
    times: Optional[List[datetime]]
    pukes: Optional[List[int]]
    skips: Optional[List[int]]
    card1: Optional[int]
    card2: Optional[int]
    card3: Optional[int]


class TeamInDB(TeamBase):
    id: int
    question_scores: List[bool]
    time_scores: List[int]
    times: List[datetime]
    pukes: List[int]
    skips: List[int]
    total: int
    classification: int
    members: List[UserInDB]

    class Config:
        orm_mode = True


class TeamMeInDB(TeamInDB):
    card1: int
    card2: int
    card3: int


class StaffScoresTeamUpdate(BaseModel):
    question_score: bool = False
    time_score: conint(ge=0) = 0
    pukes: conint(ge=0) = 0
    skips: int = 0


class StaffCardsTeamUpdate(BaseModel):
    card1: Optional[bool]
    card2: Optional[bool]
    card3: Optional[bool]
