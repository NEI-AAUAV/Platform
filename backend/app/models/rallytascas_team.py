from sqlalchemy import Date, String, Column, ARRAY

from app.db.base_class import Base


class Teams(Base):
    __tablename__ = "rallytascas_teams"

    id = Column(int, primary_key=True)
    name = Column(String)
    scores = Column(ARRAY(int))
    times = Column(ARRAY(float))