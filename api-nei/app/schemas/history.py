from datetime import date
from typing import Literal, Optional

from pydantic import BaseModel, ConfigDict


class HistoryCategoryOut(BaseModel):
    """CMS-managed (`history_category` table), not a hardcoded enum — adding,
    renaming or recoloring a category is a Directus-only change."""

    model_config = ConfigDict(from_attributes=True)

    slug: str
    label: str
    color: Optional[str] = None


class HistoryMediaOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    url: str
    thumb: str
    caption: Optional[str] = None
    source: Literal["upload", "drive"]


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


class HistoryOut(HistoryBase):
    """Public shape for the timeline: editorial fields plus a resolved
    gallery. `gallery_count` includes Drive-folder images only when they
    are already known (list endpoint keeps it cheap by not calling Drive
    for every row); the detail/gallery endpoint always resolves it."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    category: Optional[HistoryCategoryOut] = None
    featured: bool
    mandate: Optional[str] = None
    external_url: Optional[str] = None
    external_label: Optional[str] = None
    media: list[HistoryMediaOut] = []
    has_drive_gallery: bool = False


class HistoryGalleryOut(BaseModel):
    id: int
    title: str
    media: list[HistoryMediaOut]
