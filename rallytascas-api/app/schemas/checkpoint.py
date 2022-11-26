from pydantic import BaseModel
from typing import Optional, List, Union
from datetime import datetime

class CheckPointBase(BaseModel):
    name: str
    shot_name : str
    description : str

class CheckPointInDB(CheckPointBase):
    id: int
    
    class Config:
        orm_mode = True
