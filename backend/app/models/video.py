from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey, String, Text, ARRAY, Table
from sqlalchemy.orm import relationship

from .video_tag import VideoTag
from app.api import deps

from sqlalchemy.orm import Session, validates

from app.core.config import settings
from app.db.base_class import Base



association_table = Table(
    "association_table",
    Base.metadata,
    Column("video", ForeignKey(settings.SCHEMA_NAME + ".video.id"), primary_key=True),
    Column("video_tag", ForeignKey(settings.SCHEMA_NAME + ".video_tag.id"), primary_key=True),
    schema=settings.SCHEMA_NAME,
)

class Video(Base):
    __tablename__ = "video"

    id = Column(Integer, primary_key=True, autoincrement=True)
    ytld =  Column(String(255))
    title = Column(String(255))
    subtitle = Column(String(255))
    image = Column(Text)
    created = Column(DateTime, index=True)
    playlist = Column(SmallInteger)
    tags = relationship("VideoTag", secondary=association_table)
    
