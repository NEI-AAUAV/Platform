from pydantic import BaseModel
from typing import List, Optional
from .group import Group


class StandingsCreate(BaseModel):
    team: str
    pts: Optional[int]
    wins: Optional[int]
    ties: Optional[int]
    losses: Optional[int]
    goals_scored: Optional[int]
    goals_against: Optional[int]
    goal_difference: Optional[int]

class StandingsUpdate(BaseModel):
    pts: Optional[int]
    wins: Optional[int]
    ties: Optional[int]
    losses: Optional[int]
    goals_scored: Optional[int]
    goals_against: Optional[int]
    goal_difference: Optional[int]

class StandingsInDB(BaseModel):
    # standings: List[StandingsRow]
    id: int
    group: Group

    class Config:
        orm_mode = True
