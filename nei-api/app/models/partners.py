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
    banner_url = Column(String(255))
    banner_image = Column(String(255))
    banner_until = Column(DateTime)