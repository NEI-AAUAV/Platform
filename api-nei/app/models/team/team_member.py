import uuid
from typing import Optional

from sqlalchemy import String, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User
from .team_role import TeamRole

# NOTE: this model (mandate + role_id columns) does not match the live
# `nei.team_member` table (header, user_id, section_id, name, role, weight
# — see nei-directus/README.md and the Directus plan's "Bloqueio
# conhecido"). The table was restructured by a migration
# (`d4e5f6a7b8c9`) that isn't in this repo's alembic/versions/. Until that
# revision is recovered and this model is reconciled with the real schema,
# api-nei's team endpoints are likely already broken against the current
# database — out of scope for the Directus CMS work, not introduced by it.


class TeamMember(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    _header: Mapped[Optional[str]] = mapped_column("header", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    header_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    mandate: Mapped[str] = mapped_column(String(7), index=True)
    user_id: Mapped[Optional[int]] = mapped_column(ForeignKey(User.id), index=True)
    role_id: Mapped[int] = mapped_column(ForeignKey(TeamRole.id), index=True)

    user: Mapped[Optional[User]] = relationship(User, foreign_keys=[user_id])
    role: Mapped[TeamRole] = relationship(TeamRole, foreign_keys=[role_id])

    @hybrid_property
    def header(self) -> Optional[str]:
        if self.header_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.header_asset}"
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[str]):
        self._header = header
