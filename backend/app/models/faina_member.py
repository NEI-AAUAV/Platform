from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class FainaMember(Base):
    __tablename__ = "faina_member"

    id = Column(Integer, primary_key=True, autoincrement=True)
    #member_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id"), index=True)
    year_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".faina.mandato"), index=True)
    role_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".faina_roles.id"), index=True)

    #member = relationship("Users", foreign_keys=[member_id])
    role = relationship("FainaRoles", foreign_keys=[role_id])
    mandato = relationship("Faina", foreign_keys=[year_id])