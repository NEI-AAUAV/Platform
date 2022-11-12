from pydantic import BaseModel
from datetime import datetime

from typing import Optional

class MerchandisingsBase(BaseModel):
    name: str
    image: str
    price: Optional[int]
    number_of_items: Optional[int]

class MerchandisingsCreate(MerchandisingsBase):
    """Properties to receive via API on create."""
    pass

class MerchandisingsUpdate():
    #Reject updates
    pass

class MerchandisingsInDB(MerchandisingsBase):
    id: int

    class Config:
        orm_mode = True