
from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class PartnerBase(BaseModel):
    header: str
    company: str
    description: str
    content: Optional[str]
    link: str
    banner_url: Optional[str]
    banner_image: Optional[str]
    banner_until: Optional[datetime]


class PartnerCreate(PartnerBase):
    """Properties to receive via API on create."""
    pass


class PartnerUpdate():
    #Reject updates
    pass


class PartnerInDB(PartnerBase):
    id: int

    class Config:
        orm_mode = True
