from typing import Optional

from pydantic import BaseModel, ConfigDict


class MerchBase(BaseModel):
    name: str
    # Nullable in the DB and writable from the CMS.
    image: Optional[str] = None
    price: Optional[float]
    number_of_items: Optional[int]
    discontinued: bool


class MerchCreate(MerchBase):
    """Properties to receive via API on create."""

    pass


class MerchUpdate(BaseModel):
    """Updates are not supported: any field is rejected."""

    model_config = ConfigDict(extra="forbid")


class MerchInDB(MerchBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
