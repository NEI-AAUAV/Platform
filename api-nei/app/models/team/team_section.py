from typing import List, TYPE_CHECKING

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base
from .team_category import TeamCategory

if TYPE_CHECKING:
    from .team_member import TeamMember


class TeamSection(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    category_id: Mapped[int] = mapped_column(
        ForeignKey(TeamCategory.id, ondelete="CASCADE"), index=True
    )
    name: Mapped[str] = mapped_column(String(120))
    weight: Mapped[int] = mapped_column(default=0)

    category: Mapped[TeamCategory] = relationship(
        TeamCategory, foreign_keys=[category_id], back_populates="sections"
    )
    members: Mapped[List["TeamMember"]] = relationship(
        "TeamMember",
        back_populates="section",
        order_by="TeamMember.weight",
    )
