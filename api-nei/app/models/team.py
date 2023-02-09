from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Team(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    _header = Column("header", String(2048))
    mandate = Column(Integer, index=True)
    user_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + '.user.id'),
        index=True)
    role_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + '.team_role.id'),
        index=True)

    user = relationship("User", foreign_keys=[user_id])
    role = relationship("TeamRole", foreign_keys=[role_id])

    @hybrid_property
    def header(self) -> Optional[AnyHttpUrl]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[AnyHttpUrl]):
        self._header = header
