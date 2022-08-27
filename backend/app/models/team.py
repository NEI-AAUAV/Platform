from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Team(Base):
    __tablename__ = "team"

    id = Column(Integer, primary_key=True, autoincrement=True)
    header = Column(String(255))
    mandato = Column(Integer, index=True)
    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + '.users.id'), index=True)
    role_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + '.team_roles.id'), index=True)

    user = relationship("Users", foreign_keys=[user_id])
    role = relationship("TeamRoles", foreign_keys=[role_id])
