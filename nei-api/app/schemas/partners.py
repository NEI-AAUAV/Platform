
from pydantic import BaseModel
from datetime import datetime

from typing import Optional

class PartnersBase(BaseModel):
    header: str
    company: str
    description: str
    content: Optional[str]
    link: str
    banner_url: Optional[str]
    banner_image: Optional[str]
    banner_until: Optional[datetime]

class PartnersCreate(PartnersBase):
    """Properties to receive via API on create."""
    pass

class PartnersUpdate():
    #Reject updates
    pass

class PartnersInDB(PartnersBase):
    id: int

    class Config:
        orm_mode = True