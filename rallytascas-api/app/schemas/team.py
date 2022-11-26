from pydantic import BaseModel
from typing import Optional, List, Union
from datetime import datetime


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
    card1: bool
    card2: bool
    card3: bool
    classification: int

    class Config:
        orm_mode = True


class Checkpoint(BaseModel):
    checkpoint_id: int
    score: int
