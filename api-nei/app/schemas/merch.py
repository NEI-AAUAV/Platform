from typing import Optional

from pydantic import BaseModel


class MerchBase(BaseModel):
    name: str
    image: str
    price: Optional[int]
    number_of_items: Optional[int]

class MerchCreate(MerchBase):
    """Properties to receive via API on create."""
    pass

class MerchUpdate():
    #Reject updates
    pass

class MerchInDB(MerchBase):
    id: int

    class Config:
        orm_mode = True