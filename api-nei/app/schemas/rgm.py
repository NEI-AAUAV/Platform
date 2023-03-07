from typing import Optional

from pydantic import BaseModel, constr


class RgmBase(BaseModel):
    category: str
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[constr(regex=r"^\d{4}(\/\d{2})?$")]
    file: Optional[str]


class RgmCreate(RgmBase):
    """Properties to receive via API on create."""
    pass


class RgmUpdate():
    #Reject updates
    pass


class RgmInDB(RgmBase):
    id: int
    mandate: constr(regex=r"^\d{4}(\/\d{2})?$")

    class Config:
        orm_mode = True
