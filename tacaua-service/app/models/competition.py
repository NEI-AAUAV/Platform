from sqlalchemy import Column, SmallInteger, Integer, String, Text, Enum, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.schemas.competition import RankByEnum, TiebreakEnum, SystemEnum
from app.db.base_class import Base


class Competition(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    name = Column(String(20), nullable=False)
    system = Column(
        Enum(SystemEnum, name="system_enum", inherit_schema=True),
        nullable=False
    )
    rank_by = Column(
        Enum(RankByEnum, name="rank_by_enum", inherit_schema=True),
        nullable=False
    )
    tiebreaks = Column(
        ARRAY(Enum(TiebreakEnum, name="tiebreak_enum", inherit_schema=True))
    )
    started = Column(Boolean, default=False)
    public = Column(Boolean, default=False)

    rounds = relationship(
        "Round",
        cascade="all, delete",
    )
