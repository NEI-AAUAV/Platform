from typing import Optional, List, Annotated
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from .user import ListingUser


class TeamBase(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    total: int
    classification: int


class ListingTeam(TeamBase):
    """
    The schema returned when listing multiple teams
    """

    num_members: int

    last_checkpoint_time: Optional[datetime]
    last_checkpoint_score: Optional[int]


class DetailedTeam(TeamBase):
    question_scores: List[bool]
    time_scores: List[int]
    times: List[datetime]
    pukes: List[int]
    skips: List[int]

    card1: int
    card2: int
    card3: int

    score_per_checkpoint: List[int]
    members: List[ListingUser]


class TeamCreate(BaseModel):
    name: str


class TeamUpdate(BaseModel):
    name: Optional[str] = None
    question_scores: Optional[List[bool]] = None
    time_scores: Optional[List[int]] = None
    times: Optional[List[datetime]] = None
    pukes: Optional[List[int]] = None
    skips: Optional[List[int]] = None
    card1: Optional[int] = None
    card2: Optional[int] = None
    card3: Optional[int] = None


class AdminCheckPointSelect(BaseModel):
    # For admin's only
    checkpoint_id: Optional[int] = None


class TeamScoresUpdate(AdminCheckPointSelect):
    skips: int = 0
    question_score: bool = False
    time_score: Annotated[int, Field(strict=True, ge=0)] = 0
    pukes: Annotated[int, Field(strict=True, ge=0)] = 0


class TeamCardsUpdate(AdminCheckPointSelect):
    card1: Optional[bool] = None
    card2: Optional[bool] = None
    card3: Optional[bool] = None
