from datetime import datetime
from pydantic import BaseModel, ConfigDict

from app.utils import optional


class EventBase(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    name: str
    start: datetime
    end: datetime


class ListingEvent(EventBase):
    id: int


class DetailedEvent(EventBase):
    id: int


class CreateEvent(EventBase):
    pass


@optional()
class UpdateEvent(EventBase):
    pass
