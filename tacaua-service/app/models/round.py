from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey, Computed
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Round(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    group_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".group.id", ondelete='CASCADE'),
        nullable=False,
        index=True
    )
    number = Column(SmallInteger, nullable=False)
    name = Column(String(20), Computed("'Jornada ' || number::TEXT"))
    # win_criteria = Column(String)   # TODO: future feature (best-of-3, race-to-2, ...)

    matches = relationship(
        "Match",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )
