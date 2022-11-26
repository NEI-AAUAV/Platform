from sqlalchemy import String, Column, ARRAY, DateTime, Integer, Boolean
from typing import Union
from sqlalchemy.ext.mutable import MutableList
from app.db.base_class import Base


class Team(Base):
    __tablename__ = "team"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String)
    scores = Column(MutableList.as_mutable(ARRAY(Integer)), default=[])
    times = Column(MutableList.as_mutable(ARRAY(DateTime(timezone=False))), default=[])
    card1 = Column(Boolean, default=False)
    card2 = Column(Boolean, default=False)
    card3 = Column(Boolean, default=False)
    classification = Column(Integer, default=-1)
