from typing import List, TYPE_CHECKING

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base
from .team_mandate import TeamMandate

if TYPE_CHECKING:
    from .team_member import TeamMember


class TeamSection(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    mandate_id: Mapped[int] = mapped_column(
        ForeignKey(TeamMandate.id, ondelete="CASCADE"), nullable=False, index=True
    )
    name: Mapped[str] = mapped_column(String(120))
    weight: Mapped[int] = mapped_column(default=0, server_default="0")

    mandate_ref: Mapped[TeamMandate] = relationship(
        TeamMandate, foreign_keys=[mandate_id], back_populates="sections"
    )
    members: Mapped[List["TeamMember"]] = relationship(
        "TeamMember",
        back_populates="section",
        order_by="TeamMember.weight",
    )
