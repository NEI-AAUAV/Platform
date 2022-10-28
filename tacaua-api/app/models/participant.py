from operator import gt
from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey

from app.db.base_class import Base

from app.core.config import settings


class Participant(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    team_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id", ondelete='CASCADE'),
        nullable=False,
        index=True
    )
    name = Column(String(50), nullable=False)
    number = Column(SmallInteger)
