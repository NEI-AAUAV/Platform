from typing import Optional, List, Annotated
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from .user import UserInDB


class TeamBase(BaseModel):
    name: Optional[str] = None


class TeamCreate(TeamBase):
    name: str


class TeamUpdate(TeamBase):
    question_scores: Optional[List[bool]] = None
    time_scores: Optional[List[int]] = None
    times: Optional[List[datetime]] = None
    pukes: Optional[List[int]] = None
    skips: Optional[List[int]] = None
    card1: Optional[int] = None
    card2: Optional[int] = None
    card3: Optional[int] = None


class TeamInDB(TeamBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    question_scores: List[bool]
    time_scores: List[int]
    times: List[datetime]
    pukes: List[int]
    skips: List[int]
    total: int
    classification: int
    members: List[UserInDB]


class TeamMeInDB(TeamInDB):
    card1: int
    card2: int
    card3: int


class StaffScoresTeamUpdate(BaseModel):
    question_score: bool = False
    time_score: Annotated[int, Field(strict=True, ge=0)] = 0
    pukes: Annotated[int, Field(strict=True, ge=0)] = 0
    skips: int = 0


class StaffCardsTeamUpdate(BaseModel):
    card1: Optional[bool] = None
    card2: Optional[bool] = None
    card3: Optional[bool] = None
