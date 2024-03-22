from typing import Annotated

from pydantic import BaseModel, Field, ConfigDict


class RedirectBase(BaseModel):
    alias: Annotated[str, Field(max_length=256)]
    redirect: str


class RedirectInDB(RedirectBase):
    model_config = ConfigDict(from_attributes=True)

    id: int


class RedirectCreate(RedirectBase):
    """Properties to receive via API on creation."""

    pass


class RedirectUpdate(RedirectBase):
    """Properties to receive via API on update."""

    pass
