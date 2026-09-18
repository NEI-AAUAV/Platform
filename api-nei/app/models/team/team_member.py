import uuid
from typing import Optional

from sqlalchemy import ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User
from .team_section import TeamSection
from .team_mandate import TeamMandate


class TeamMember(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    _header: Mapped[Optional[str]] = mapped_column("header", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    header_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    section_id: Mapped[int] = mapped_column(
        ForeignKey(TeamSection.id, ondelete="CASCADE"), index=True
    )
    user_id: Mapped[Optional[int]] = mapped_column(ForeignKey(User.id), index=True)
    name: Mapped[str] = mapped_column(String(120))
    role: Mapped[str] = mapped_column(String(120))
    weight: Mapped[int] = mapped_column(default=0)
    # Denormalized from section_id -> section -> category -> mandate.
    # Non-authoritative: section_id remains the real link. Lets the CMS
    # list every member of a mandate in one query without joining through
    # category/section. Nullable; kept in sync only where it's written
    # (the Directus CMS field is read-only for this reason).
    mandate: Mapped[Optional[str]] = mapped_column(
        ForeignKey(TeamMandate.mandate, ondelete="CASCADE"), index=True
    )

    section: Mapped[TeamSection] = relationship(
        TeamSection, foreign_keys=[section_id], back_populates="members"
    )
    user: Mapped[Optional[User]] = relationship(User, foreign_keys=[user_id])
    mandate_ref: Mapped[Optional[TeamMandate]] = relationship(
        TeamMandate, foreign_keys=[mandate], back_populates="members"
    )

    @hybrid_property
    def header(self) -> Optional[str]:
        if self.header_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.header_asset}"
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[str]):
        self._header = header
