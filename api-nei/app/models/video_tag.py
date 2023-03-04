from sqlalchemy import Column, Integer, String

from app.db.base_class import Base


class VideoTag(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(256))
    color = Column(String(18))
