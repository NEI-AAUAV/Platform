from typing import Optional

from pydantic import BaseModel, ConfigDict


class MerchBase(BaseModel):
    name: str
    image: str
    price: Optional[float]
    number_of_items: Optional[int]
    discontinued: bool


class MerchCreate(MerchBase):
    """Properties to receive via API on create."""

    pass


class MerchUpdate:
    # Reject updates
    pass


class MerchInDB(MerchBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
