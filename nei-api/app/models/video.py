from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey, String, Text, Table
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


video_video_tags = Table(
    "video_video_tags",
    Base.metadata,
    Column("video", ForeignKey(settings.SCHEMA_NAME + ".video.id"), primary_key=True),
    Column("video_tag", ForeignKey(settings.SCHEMA_NAME + ".video_tag.id"), primary_key=True),
    schema=settings.SCHEMA_NAME,
)

class Video(Base):
    __tablename__ = "video"

    id = Column(Integer, primary_key=True, autoincrement=True)
    youtube_id =  Column(String(255))
    title = Column(String(255))
    subtitle = Column(String(255))
    image = Column(Text)
    created_at = Column(DateTime, index=True)
    playlist = Column(SmallInteger)
    tags = relationship("VideoTag", secondary=video_video_tags)
    
    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
