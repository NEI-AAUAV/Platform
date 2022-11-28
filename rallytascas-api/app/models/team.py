from sqlalchemy import String, Column, ARRAY, DateTime, Integer, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.ext.mutable import MutableList

from app.db.base_class import Base


class Team(Base):
    __tablename__ = "team"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String)
    question_scores = Column(MutableList.as_mutable(ARRAY(Boolean)), default=[])
    time_scores = Column(MutableList.as_mutable(ARRAY(Integer)), default=[])
    times = Column(MutableList.as_mutable(ARRAY(DateTime(timezone=False))), default=[])
    pukes = Column(MutableList.as_mutable(ARRAY(Integer)), default=[])
    skips = Column(MutableList.as_mutable(ARRAY(Integer)), default=[])
    total = Column(Integer, default=0)
    card1 = Column(Integer, default=-1)
    card2 = Column(Integer, default=-1)
    card3 = Column(Integer, default=-1)
    classification = Column(Integer, default=-1)

    members = relationship("User")
