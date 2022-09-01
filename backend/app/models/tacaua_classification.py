from sqlalchemy import Column, ForeignKey, SmallInteger, Integer
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TacaUAClassification(Base):
    __tablename__ = "tacaua_classification"

    team_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_team.id"), primary_key=True)
    modality_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_modality.id"), primary_key=True)
    position = Column(SmallInteger)
    played = Column(SmallInteger, default=0)
    won = Column(SmallInteger, default=0)
    drew = Column(SmallInteger, default=0)
    lost = Column(SmallInteger, default=0)
    forfeited = Column(SmallInteger, default=0)
    scored_for = Column(SmallInteger, nullable=True)
    scored_agst = Column(SmallInteger, nullable=True)
    points = Column(SmallInteger, default=0)

    team = relationship("TacaUATeam")
