from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey, Enum

from app.db.base_class import Base


class Course(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(60))
    initials = Column(String(16))
    color = Column(String(30))
    image = Column(Text, default='')  # TODO: default
