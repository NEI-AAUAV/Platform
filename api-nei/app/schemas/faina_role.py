from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated


class FainaRoleBase(BaseModel):
    name: Annotated[str, Field(max_length=20)]
    weight: Optional[int]


class FainaRoleCreate(FainaRoleBase):
    """Properties to receive via API on creation."""
    pass


class FainaRoleUpdate(FainaRoleBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=20)]
    weight: Optional[int]


class FainaRoleInDB(FainaRoleBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
