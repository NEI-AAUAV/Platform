from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated


class FainaRolesBase(BaseModel):
    name: Annotated[str, Field(max_length=20)]
    weight: Optional[int]


class FainaRolesCreate(FainaRolesBase):
    """Properties to receive via API on creation."""
    pass


class FainaRolesUpdate(FainaRolesBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=20)]
    weight: Optional[int]


class FainaRolesInDB(FainaRolesBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
