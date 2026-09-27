import uuid
from datetime import date
from typing import Optional

from sqlalchemy import (
    BigInteger,
    Boolean,
    CheckConstraint,
    Date,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.assets import asset_url
from app.core.config import settings
from app.db.base_class import Base


class History(Base):
    @declared_attr.directive
    def __table_args__(cls):
        return (
            # The page sorts, labels and anchors by mandate: AAAA/AA only.
            CheckConstraint("mandate ~ '^[0-9]{4}/[0-9]{2}$'", name="mandate_format"),
            Base.__table_args__,
        )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    moment: Mapped[date] = mapped_column(Date, index=True)
    title: Mapped[str] = mapped_column(String(120))
    body: Mapped[Optional[str]] = mapped_column(Text)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    # Editor-written description of `image` for screen readers. Blank means
    # the image is treated as decorative (it sits right next to the title).
    image_alt: Mapped[Optional[str]] = mapped_column(String(200))

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
    # Academic year the milestone belongs to, e.g. "2025/26". Editorial (not
    # derived), but the UI falls back to deriving it from `moment` when this
    # is blank.
    mandate: Mapped[Optional[str]] = mapped_column(String(7))
    # Directus validates this is a drive.google.com folder link; api-nei
    # only ever treats it as an opaque URL to resolve at read time.
    drive_folder_url: Mapped[Optional[str]] = mapped_column(String(2048))

    category: Mapped[Optional["HistoryCategory"]] = relationship("HistoryCategory")
    media: Mapped[list["HistoryMedia"]] = relationship(
        "HistoryMedia",
        # `id` breaks weight ties (editors may leave several at 0), so the
        # gallery order never depends on the query plan.
        order_by="[HistoryMedia.weight, HistoryMedia.id]",
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
    Directus-only change (no deploy, unlike the old hardcoded enum).

    `slug` is the stable identifier shared links use (`?categoria=<slug>`):
    the database refuses to change it once created (see migration
    b7d9f1a3c5e8). Renaming a category means editing `label`."""

    @declared_attr.directive
    def __table_args__(cls):
        return (
            CheckConstraint("slug ~ '^[a-z0-9-]+$'", name="slug_format"),
            Base.__table_args__,
        )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    slug: Mapped[str] = mapped_column(String(30), unique=True)
    label: Mapped[str] = mapped_column(String(60))
    color: Mapped[Optional[str]] = mapped_column(String(60))
    weight: Mapped[int] = mapped_column(Integer, nullable=False, default=0)


class HistoryMedia(Base):
    """One gallery photo for a milestone: either a Directus upload or a
    single Google Drive file link. Exactly one of the two is set: Directus
    writes straight to PostgreSQL, so the check lives in the schema."""

    @declared_attr.directive
    def __table_args__(cls):
        return (
            # Created by migration a3f5c7e9b1d4 as ck_history_media_single_source.
            CheckConstraint(
                "(photo_asset IS NULL) <> (drive_url IS NULL)", name="single_source"
            ),
            Base.__table_args__,
        )

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
