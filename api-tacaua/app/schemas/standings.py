from pydantic import BaseModel
from typing import List, Optional
from .match import Match


class StandingsCreate(BaseModel):
    team: str
    pts: Optional[int]
    wins: Optional[int]
    ties: Optional[int]
    losses: Optional[int]
    goals_scored: Optional[int]
    goals_against: Optional[int]
    goal_difference: Optional[int]

    classification: Optional[int]
    has_passed: Optional[bool]

class StandingsUpdate(BaseModel):
    pts: Optional[int]
    wins: Optional[int]
    ties: Optional[int]
    losses: Optional[int]
    goals_scored: Optional[int]
    goals_against: Optional[int]
    goal_difference: Optional[int]

    classification: Optional[int]
    has_passed: Optional[bool]

class StandingsInDB(BaseModel):
    # standings: List[StandingsRow]
    id: int

    class Config:
        orm_mode = True
