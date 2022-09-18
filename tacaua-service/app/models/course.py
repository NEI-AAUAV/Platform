from sqlalchemy import Column, Integer, String, Text

from app.db.base_class import Base


class Course(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(60), nullable=False)
    initials = Column(String(16), nullable=False)
    color = Column(String(30), default="white")
    image = Column(Text)
