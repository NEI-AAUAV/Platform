from typing import List, Optional

from pydantic import BaseModel, constr

from .round import Round
from .team import TeamLazy


class GroupBase(BaseModel):
    name: Optional[constr(max_length=20)]


class GroupCreate(BaseModel):
    competition_id: int


class GroupUpdate(BaseModel):
    number: Optional[int]
    teams_id: List[int] = []


class Group(GroupBase):
    id: int
    number: int
    rounds: List[Round]
    teams: List[TeamLazy]
   
    class Config:
        orm_mode = True
