from sqlalchemy import DateTime, String, Text, Column, Integer

from app.db.base_class import Base


class Partners(Base):
    __tablename__ = "partners"

    id = Column(Integer, primary_key=True, autoincrement=True)
    header = Column(String(255))
    company = Column(String(255))
    description = Column(Text)
    content = Column(String(255))
    link = Column(String(255))
    bannerUrl = Column(String(255))
    bannerImage = Column(String(255))
    bannerUntil = Column(DateTime)