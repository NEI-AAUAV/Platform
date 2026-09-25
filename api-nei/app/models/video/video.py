import uuid
from datetime import datetime
from typing import Optional, List

from sqlalchemy import (
    BigInteger,
    Column,
    UniqueConstraint,
    SmallInteger,
    DateTime,
    ForeignKey,
    String,
    Table,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.assets import asset_url
from app.core.config import settings
from app.db.base_class import Base
from .video_tag import VideoTag


# Pure join table. The surrogate `id` (alembic a7c2e4f6b8d1) exists only
# because Directus cannot introspect a composite-PK junction; it is a known,
# contained concession and the (video_id, video_tag_id) pair stays UNIQUE.
# Inserts through the ORM never set it (server default).
video__video_tags_association_table = Table(
    "video__video_tags",
    Base.metadata,
    Column("id", BigInteger, primary_key=True, autoincrement=True),
    Column(
        "video_id",
        ForeignKey(f"{settings.SCHEMA_NAME}.video.id", ondelete="CASCADE"),
        nullable=False,
    ),
    Column(
        "video_tag_id",
        ForeignKey(VideoTag.id, ondelete="CASCADE"),
        nullable=False,
    ),
    UniqueConstraint("video_id", "video_tag_id", name="uq_video__video_tags_video_tag"),
    schema=settings.SCHEMA_NAME,
)


class Video(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    youtube_id: Mapped[Optional[str]] = mapped_column(String(256))
    title: Mapped[str] = mapped_column(String(256))
    subtitle: Mapped[Optional[str]] = mapped_column(String(256))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    created_at: Mapped[datetime] = mapped_column(index=True)
    playlist: Mapped[Optional[int]] = mapped_column(SmallInteger)

    tags: Mapped[List[VideoTag]] = relationship(
        VideoTag, secondary=video__video_tags_association_table
    )

    @hybrid_property
    def image(self) -> Optional[str]:
        if self.image_asset:
            return asset_url(self.image_asset)
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
