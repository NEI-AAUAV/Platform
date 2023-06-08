from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class FainaMember(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    member_id = Column(
        Integer, 
        ForeignKey(settings.SCHEMA_NAME + ".user.id"),
        index=True)
    faina_id = Column(
        Integer, 
        ForeignKey(settings.SCHEMA_NAME + ".faina.id"),
        index=True)
    role_id = Column(
        Integer, 
        ForeignKey(settings.SCHEMA_NAME + ".faina_role.id"),
        index=True)

    member = relationship("User", foreign_keys=[member_id])
    role = relationship("FainaRole", foreign_keys=[role_id])
