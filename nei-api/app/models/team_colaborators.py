from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TeamColaborators(Base):
    __tablename__ = "team_colaborators"

    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + '.users.id'), primary_key=True)
    mandate = Column(Integer, primary_key=True)

    user = relationship("Users")
