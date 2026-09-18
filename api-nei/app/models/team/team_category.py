from typing import List, TYPE_CHECKING

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base
from .team_mandate import TeamMandate

if TYPE_CHECKING:
    from .team_section import TeamSection


class TeamCategory(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    mandate: Mapped[str] = mapped_column(
        ForeignKey(TeamMandate.mandate, ondelete="CASCADE"), index=True
    )
    name: Mapped[str] = mapped_column(String(120))
    weight: Mapped[int] = mapped_column(default=0)

    mandate_ref: Mapped[TeamMandate] = relationship(
        TeamMandate, foreign_keys=[mandate], back_populates="categories"
    )
    sections: Mapped[List["TeamSection"]] = relationship(
        "TeamSection",
        back_populates="category",
        order_by="TeamSection.weight",
    )
