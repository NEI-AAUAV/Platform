from sqlalchemy import String, Column, ARRAY, DateTime, Integer
from typing import Union
from sqlalchemy.ext.mutable import MutableList
from app.db.base_class import Base


class Team(Base):
    __tablename__ = "team"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    scores = Column(MutableList.as_mutable(ARRAY(Integer)))
    times = Column(MutableList.as_mutable(ARRAY(DateTime(timezone=False))))