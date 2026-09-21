from datetime import date
from typing import Optional

from pydantic import BaseModel, ConfigDict


class HistoryBase(BaseModel):
    moment: date
    title: str
    # Nullable in the DB and writable from the CMS.
    body: Optional[str] = None
    image: Optional[str]


class HistoryCreate(HistoryBase):
    """Properties to receive via API on create."""

    pass


class HistoryUpdate(BaseModel):
    """Updates are not supported: any field is rejected."""

    model_config = ConfigDict(extra="forbid")


class HistoryInDB(HistoryBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
