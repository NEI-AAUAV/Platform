from typing import Optional
from typing_extensions import Annotated

from pydantic import BaseModel, Field


class RedirectBase(BaseModel):
    alias: Annotated[str, Field(max_length=255)]
    redirect: str


class RedirectInDB(RedirectBase):
    id: int

    class Config:
        orm_mode = True


class RedirectCreate(RedirectBase):
    """Properties to receive via API on creation."""
    pass


class RedirectUpdate(RedirectBase):
    """Properties to receive via API on update."""
    pass
