from typing import Optional

from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User
from .team_role import TeamRole


class TeamMember(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    _header: Mapped[Optional[str]] = mapped_column("header", String(2048))
    mandate: Mapped[str] = mapped_column(String(7), index=True)
    user_id: Mapped[Optional[int]] = mapped_column(ForeignKey(User.id), index=True)
    role_id: Mapped[int] = mapped_column(ForeignKey(TeamRole.id), index=True)

    user: Mapped[Optional[User]] = relationship(User, foreign_keys=[user_id])
    role: Mapped[TeamRole] = relationship(TeamRole, foreign_keys=[role_id])

    @hybrid_property
    def header(self) -> Optional[str]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[str]):
        self._header = header
