from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Round(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    competition_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".competition.id"), index=True)
    name = Column(String(20))
    win_criteria = Column(String)