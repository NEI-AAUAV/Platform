from datetime import datetime
from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated



class TeamsBase(BaseModel):
    name: str
    scores: Optional(list)
    times: Optional(list)

    
class TeamsCreate(TeamsBase):
    name: str


class TeamsUpdate(TeamsBase):
    name: str
    scores: list
    times: list

class TeamsInDB(TeamsBase):
    id: int
    
    class Config:
        orm_mode = True

class Checkpoint(BaseModel):
    checkpoint_id: int
    score: int
    time: float
