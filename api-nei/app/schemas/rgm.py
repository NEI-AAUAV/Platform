from pydantic import BaseModel

from typing import Optional

class RgmBase(BaseModel):
    category: str
    mandate: Optional[int]
    file: Optional[str]

class RgmCreate(RgmBase):
    """Properties to receive via API on create."""
    pass

class RgmUpdate():
    #Reject updates
    pass

class RgmInDB(RgmBase):
    id: int
    mandate: int

    class Config:
        orm_mode = True