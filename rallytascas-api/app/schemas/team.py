from pydantic import BaseModel
from typing import Optional, List, Union
from datetime import datetime

class TeamBase(BaseModel):
    name: str
    scores: Optional[List[int]]
    times: Optional[List[datetime]]

    
class TeamCreate(TeamBase):
    name: str


class TeamUpdate(TeamBase):
    name: str
    scores: List[int]
    times: List[datetime]


class TeamInDB(TeamBase):
    id: int
    
    class Config:
        orm_mode = True

class Checkpoint(BaseModel):
    checkpoint_id: int
    score: int
