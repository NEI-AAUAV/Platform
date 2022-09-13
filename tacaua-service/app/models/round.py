from operator import index
from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey, ForeignKeyConstraint
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Round(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    competition_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".competition.id", ondelete='CASCADE'),
        index=True
    )
    number = Column(SmallInteger, nullable=False)
    name = Column(String(20))
    win_criteria = Column(String)   # TODO:

    matches = relationship(
        "Match",
        cascade="all, delete",
        passive_deletes=True,
    )
