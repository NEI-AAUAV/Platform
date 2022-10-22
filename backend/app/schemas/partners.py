
from pydantic import BaseModel
from datetime import datetime

from typing import Optional

class PartnersBase(BaseModel):
    header: str
    company: str
    description: str
    content: str
    link: str
    bannerUrl: Optional[str]
    bannerImage: Optional[str]
    bannerUntil: Optional[datetime]

class PartnersCreate(PartnersBase):
    """Properties to receive via API on create."""
    pass

class PartnersUpdate():
    #Reject updates
    pass

class PartnersInDB(PartnersBase):
    id: int
    bannerUrl: str
    bannerImage: str
    bannerUntil: datetime

    class Config:
        orm_mode = True