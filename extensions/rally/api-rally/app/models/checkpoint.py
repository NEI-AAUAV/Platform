from sqlalchemy import String, Column, ARRAY, DateTime, Integer
from typing import Union
from sqlalchemy.ext.mutable import MutableList
from app.db.base_class import Base


class CheckPoint(Base):
    __tablename__ = "checkpoint"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    shot_name = Column(String)
    description = Column(String)
