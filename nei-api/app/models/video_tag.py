from sqlalchemy import Column, Integer, String

from app.db.base_class import Base

class VideoTag(Base):
    __tablename__ = "video_tag"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    color = Column(String(18))
