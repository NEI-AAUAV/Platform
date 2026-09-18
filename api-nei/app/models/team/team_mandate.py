from typing import List, TYPE_CHECKING

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base

if TYPE_CHECKING:
    from .team_category import TeamCategory
    from .team_member import TeamMember


class TeamMandate(Base):
    mandate: Mapped[str] = mapped_column(String(7), primary_key=True)

    categories: Mapped[List["TeamCategory"]] = relationship(
        "TeamCategory",
        back_populates="mandate_ref",
        order_by="TeamCategory.weight",
    )
    # Denormalized flat list of every member across this mandate's
    # categories/sections — see TeamMember.mandate.
    members: Mapped[List["TeamMember"]] = relationship(
        "TeamMember",
        back_populates="mandate_ref",
        order_by="TeamMember.weight",
    )
