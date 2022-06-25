from sqlalchemy import Column, ForeignKey, SmallInteger, Integer
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TacaUAClassification(Base):
    __tablename__ = "tacaua_classification"

    team_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_team.id"), primary_key=True)
    modality_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_modality.id"), primary_key=True)
    score = Column(SmallInteger, default=0)
    games = Column(SmallInteger, default=0)
    victories = Column(SmallInteger, default=0)
    draws = Column(SmallInteger, default=0)
    defeats = Column(SmallInteger, default=0)
    g_scored = Column(SmallInteger, nullable=True)
    g_conceded = Column(SmallInteger, nullable=True)

    team = relationship("TacaUATeam")
