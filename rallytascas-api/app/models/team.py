from sqlalchemy import String, Column, ARRAY, DateTime

from app.db.base_class import Base


class Team(Base):
    __tablename__ = "team"

    id = Column(int, primary_key=True)
    name = Column(String)
    scores = Column(ARRAY(int))
    times = Column(ARRAY(DateTime(timezone=False)))
