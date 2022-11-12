from sqlalchemy import Column, Integer, String
from app.db.base_class import Base


class Seniors(Base):
    __tablename__ = "seniors"

    year = Column(Integer, primary_key=True)
    course = Column(String(3), primary_key=True)
    image = Column(String(255))
