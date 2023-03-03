from pydantic import BaseModel
from typing import Optional, List, Union
from datetime import datetime


class CheckPointBase(BaseModel):
    name: str
    shot_name: str
    description: str


class CheckPointCreate(CheckPointBase):
    id: int


class CheckPointInDB(CheckPointBase):
    id: int

    class Config:
        orm_mode = True
