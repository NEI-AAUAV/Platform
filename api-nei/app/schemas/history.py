from datetime import date
from typing import Optional

from pydantic import BaseModel


class HistoryBase(BaseModel):
    moment: date
    title: str
    body: str
    image: Optional[str]

class HistoryCreate(HistoryBase):
    """Properties to receive via API on create."""
    pass

class HistoryUpdate():
    #Reject updates
    pass

class HistoryInDB(HistoryBase):

    class Config:
        orm_mode = True
