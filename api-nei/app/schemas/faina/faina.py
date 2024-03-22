from pydantic import BaseModel, AnyHttpUrl, ConfigDict

from typing import Optional, List

from app.utils import optional
from .faina_member import FainaMemberInDB
from app.schemas.types import MandateStr


class FainaBase(BaseModel):
    # Validate mandate to only allow 2020 or 2020/21
    mandate: MandateStr


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""

    pass


@optional()
class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""

    ...


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    image: Optional[AnyHttpUrl]
    members: List[FainaMemberInDB]
