from typing import List, TYPE_CHECKING

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base

if TYPE_CHECKING:
    from .team_category import TeamCategory


class TeamMandate(Base):
    mandate: Mapped[str] = mapped_column(String(7), primary_key=True)

    categories: Mapped[List["TeamCategory"]] = relationship(
        "TeamCategory",
        back_populates="mandate_ref",
        order_by="TeamCategory.weight",
    )
