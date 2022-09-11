from sqlalchemy import Column, Boolean, Integer, String, Text, ForeignKey, SmallInteger

from app.db.base_class import Base

from app.core.config import settings


class Team(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".modality.id"), index=True)
    name = Column(String(50))
    division = Column(SmallInteger)
    group = Column(String(1))
    desclassified = Column(Boolean)
    image = Column(Text)
