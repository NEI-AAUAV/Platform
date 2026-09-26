from datetime import date
from typing import Literal, Optional

from pydantic import BaseModel, ConfigDict

from app.integrations.google_drive import DriveStatus


class HistoryCategoryOut(BaseModel):
    """CMS-managed (`history_category` table), not a hardcoded enum — adding,
    renaming or recoloring a category is a Directus-only change."""

    model_config = ConfigDict(from_attributes=True)

    slug: str
    label: str
    color: Optional[str] = None
    # Filter order set in Directus ("Ordem"), lowest first.
    weight: int = 0


class HistoryMediaOut(BaseModel):
    """`id` is namespaced by source (`upload:<row id>`, `drive:<file id>`) so
    it stays stable across requests and unique across both sources."""

    model_config = ConfigDict(from_attributes=True)

    id: str
    url: str
    thumb: str
    caption: Optional[str] = None
    source: Literal["upload", "drive"]
    width: Optional[int] = None
    height: Optional[int] = None


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
    """Public shape for the timeline: editorial fields plus the milestone's
    own `media` rows. Drive-folder photos are only listed by the gallery
    endpoint, but the list resolves them (cached, time-boxed) to fill
    `gallery_count` and `cover`. `gallery_count` is None when the Drive
    folder could not be resolved in time — unknown, not zero."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    category: Optional[HistoryCategoryOut] = None
    featured: bool
    mandate: Optional[str] = None
    external_url: Optional[str] = None
    external_label: Optional[str] = None
    media: list[HistoryMediaOut] = []
    has_drive_gallery: bool = False
    gallery_count: Optional[int] = None
    # `image`, else the first gallery photo's thumbnail.
    cover: Optional[str] = None


class HistoryGalleryOut(BaseModel):
    id: int
    title: str
    media: list[HistoryMediaOut]
    # None when the milestone links no Drive folder.
    drive_status: Optional[DriveStatus] = None
