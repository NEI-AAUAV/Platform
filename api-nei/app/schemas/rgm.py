from datetime import datetime
from enum import Enum
from typing import Optional, Annotated

from pydantic import BaseModel, ConfigDict, StringConstraints
from .types import MandateStr


class RgmCategoryEnum(str, Enum):
    """Mirrors ck_rgm_category_valid; Directus offers the same three."""

    ATA = "ATA"
    PAO = "PAO"
    RAC = "RAC"


class RgmBase(BaseModel):
    category: RgmCategoryEnum
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]
    # Real FK to RGM's own mandate calendar (rgm_mandate); `mandate` above
    # is the legacy free-text column, kept for compat. NOT NULL in the database.
    mandate_id: int
    file: Optional[str]
    date: Optional[datetime]
    title: Annotated[Optional[str], StringConstraints(max_length=264)]


class RgmInDB(RgmBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    mandate: MandateStr


class RgmMandates(BaseModel):
    data: list[str]
