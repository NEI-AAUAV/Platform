from datetime import date
from typing import Optional

from pydantic import BaseModel, ConfigDict


class HistoryBase(BaseModel):
    moment: date
    title: str
    body: str
    image: Optional[str]


class HistoryCreate(HistoryBase):
    """Properties to receive via API on create."""

    pass


class HistoryUpdate:
    # Reject updates
    pass


class HistoryInDB(HistoryBase):
    model_config = ConfigDict(from_attributes=True)
