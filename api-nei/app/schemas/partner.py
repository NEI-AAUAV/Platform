from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict


class PartnerBase(BaseModel):
    # Nullable in the DB and writable from the CMS.
    header: Optional[str] = None
    company: str
    description: Optional[str] = None
    content: Optional[str]
    link: Optional[str]
    banner_url: Optional[str]
    banner_image: Optional[str]
    banner_until: Optional[datetime]


class PartnerCreate(PartnerBase):
    """Properties to receive via API on create."""

    pass


class PartnerUpdate(BaseModel):
    """Updates are not supported: any field is rejected."""

    model_config = ConfigDict(extra="forbid")


class PartnerInDB(PartnerBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
