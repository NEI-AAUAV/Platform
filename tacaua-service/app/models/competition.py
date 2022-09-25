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
    division = Column(SmallInteger)
    name = Column(String(50), nullable=False)
    started = Column(Boolean, default=False)
    public = Column(Boolean, default=False)
    # metadata_ = Column('metadata', JSON)  # TODO: future feature

    groups = relationship(
        "Group",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )
