from sqlalchemy import Column, SmallInteger, Integer, String, Text, Enum, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.schemas.competition import RankByEnum, TiebreakEnum, TypeEnum
from app.db.base_class import Base


class Competition(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".modality.id"), primary_key=True)
    name = Column(String(20))
    type = Column(Enum(TypeEnum, name="type_enum", create_type=False))
    rank_by = Column(Enum(RankByEnum, name="rank_by_enum", create_type=False))
    tiebreaks = Column(ARRAY(Enum(TiebreakEnum, name="tiebreak_enum", create_type=False)))
    started = Column(Boolean, default=False)
    public = Column(Boolean, default=False)
    # pts_win = Column(SmallInteger, default=0)
    # pts_win_tiebreak = Column(SmallInteger, default=0)
    # pts_tie = Column(SmallInteger, default=0)
    # pts_loss_tiebreak = Column(SmallInteger, default=0)
    # pts_loss = Column(SmallInteger, default=0)
    # pts_ff = Column(SmallInteger, default=0)
    # ff_scored_for = Column(SmallInteger, default=0)
    # ff_scored_agst = Column(SmallInteger, default=0)
    # bye
    # 
