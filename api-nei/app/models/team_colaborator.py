from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TeamColaborator(Base):
    __tablename__ = "team_colaborator"

    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + '.user.id'), primary_key=True)
    mandate = Column(Integer, primary_key=True)

    user = relationship("User")
