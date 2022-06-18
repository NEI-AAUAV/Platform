from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.db.base_class import Base


class TacaUAGame(Base):
    __tablename__ = "tacaua_game"

    id = Column(Integer, primary_key=True, autoincrement=True)
    team1_id = Column(Integer, ForeignKey("tacaua_team.id"), index=True)
    team2_id = Column(Integer, ForeignKey("tacaua_team.id"), index=True)
    goals1 = Column(SmallInteger)
    goals2 = Column(SmallInteger)
    date = Column(DateTime, index=True)

    team1 = relationship("TacaUATeam")
    team2 = relationship("TacaUATeam")
