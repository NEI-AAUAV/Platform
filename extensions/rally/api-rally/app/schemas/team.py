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


class DetailedTeam(TeamBase):
    times: List[datetime]

    score_per_checkpoint: List[int]
    
    members: List[ListingUser]


class TeamCreate(BaseModel):
    name: str


class TeamUpdate(BaseModel):
    name: Optional[str] = None
    times: Optional[List[datetime]] = None
    score_per_checkpoint: Optional[List[int]] = None

class AdminCheckPointSelect(BaseModel):
    # For admin's only
    checkpoint_id: Optional[int] = None


class TeamScoresUpdate(AdminCheckPointSelect):
    score: int