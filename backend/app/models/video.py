from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey, String, Text
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base

class Video(Base):
    __tablename__ = "video"

    id = Column(Integer, primary_key=True, autoincrement=True)
    tag_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".video_tag.id", name="fk_tag_id"), index=True)
    ytld =  Column(String(255))
    title = Column(String(255))
    subtitle = Column(String(255))
    image = Column(Text)
    created = Column(DateTime, index=True)
    playlist = Column(SmallInteger)

    tag = relationship("VideoTag", foreign_keys=[tag_id])