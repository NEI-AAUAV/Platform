from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TeamColaborators(Base):
    __tablename__ = "team_colaborators"

    colaborator = Column(Integer, ForeignKey(settings.SCHEMA_NAME + '.users.id'), primary_key=True, index=True)
    mandato = Column(Integer, index=True)

    user = relationship("Users")