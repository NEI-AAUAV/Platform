from datetime import datetime
from typing import Optional, List

from sqlalchemy import (
    Column,
    SmallInteger,
    DateTime,
    ForeignKey,
    String,
    Table,
)
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from .video_tag import VideoTag


video__video_tags_association_table = Table(
    "video__video_tags",
    Base.metadata,
    Column(
        "video_id", ForeignKey(f"{settings.SCHEMA_NAME}.video.id"), primary_key=True
    ),
    Column(
        "video_tag_id",
        ForeignKey(VideoTag.id),
        primary_key=True,
    ),
    schema=settings.SCHEMA_NAME,
)


class Video(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    youtube_id: Mapped[Optional[str]] = mapped_column(String(256))
    title: Mapped[str] = mapped_column(String(256))
    subtitle: Mapped[Optional[str]] = mapped_column(String(256))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    created_at: Mapped[datetime] = mapped_column(index=True)
    playlist: Mapped[Optional[int]] = mapped_column(SmallInteger)

    tags: Mapped[List[VideoTag]] = relationship(
        VideoTag, secondary=video__video_tags_association_table
    )

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
