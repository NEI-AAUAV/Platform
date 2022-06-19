from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TacaUAGame(Base):
    __tablename__ = "tacaua_game"

    id = Column(Integer, primary_key=True, autoincrement=True)
    team1_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_team.id"), index=True)
    team2_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_team.id"), index=True)
    goals1 = Column(SmallInteger, default=0)
    goals2 = Column(SmallInteger, default=0)
    date = Column(DateTime, index=True)

    team1 = relationship("TacaUATeam")
    team2 = relationship("TacaUATeam")
