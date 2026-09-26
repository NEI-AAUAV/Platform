import uuid
from datetime import date
from typing import Optional

from sqlalchemy import BigInteger, Boolean, Date, ForeignKey, Integer, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.assets import asset_url
from app.core.config import settings
from app.db.base_class import Base


class History(Base):
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    moment: Mapped[date] = mapped_column(Date, index=True)
    title: Mapped[str] = mapped_column(String(120))
    body: Mapped[Optional[str]] = mapped_column(Text)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))

    # Editorial fields, added for the public timeline redesign.
    category_id: Mapped[Optional[int]] = mapped_column(
        BigInteger,
        ForeignKey(f"{settings.SCHEMA_NAME}.history_category.id", ondelete="SET NULL"),
        index=True,
    )
    featured: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    published: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    external_url: Mapped[Optional[str]] = mapped_column(String(2048))
    external_label: Mapped[Optional[str]] = mapped_column(String(60))
    # Academic year the milestone belongs to, e.g. "2025/26". Free text
    # because it is editorial (not derived), but the UI falls back to
    # deriving it from `moment` when this is blank.
    mandate: Mapped[Optional[str]] = mapped_column(String(7))
    # Directus validates this is a drive.google.com folder link; api-nei
    # only ever treats it as an opaque URL to resolve at read time.
    drive_folder_url: Mapped[Optional[str]] = mapped_column(String(2048))

    category: Mapped[Optional["HistoryCategory"]] = relationship("HistoryCategory")
    media: Mapped[list["HistoryMedia"]] = relationship(
        "HistoryMedia",
        order_by="HistoryMedia.weight",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    @hybrid_property
    def image(self) -> Optional[str]:
        if self.image_asset:
            return asset_url(self.image_asset)
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image


class HistoryCategory(Base):
    """CMS-managed lookup table: the timeline's category filter is built
    from these rows, so adding/renaming/recoloring a category is a
    Directus-only change (no deploy, unlike the old hardcoded enum)."""

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    slug: Mapped[str] = mapped_column(String(30), unique=True)
    label: Mapped[str] = mapped_column(String(60))
    color: Mapped[Optional[str]] = mapped_column(String(60))
    weight: Mapped[int] = mapped_column(Integer, nullable=False, default=0)


class HistoryMedia(Base):
    """One gallery photo for a milestone: either a Directus upload or a
    single Google Drive file link. Exactly one of the two is set (enforced
    by a DB check constraint, see the migration)."""

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    history_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey(f"{settings.SCHEMA_NAME}.history.id", ondelete="CASCADE"),
        index=True,
    )
    photo_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    drive_url: Mapped[Optional[str]] = mapped_column(String(2048))
    caption: Mapped[Optional[str]] = mapped_column(String(200))
    weight: Mapped[int] = mapped_column(Integer, nullable=False, default=0)

    @hybrid_property
    def url(self) -> Optional[str]:
        if self.photo_asset:
            return asset_url(self.photo_asset)
        return None
