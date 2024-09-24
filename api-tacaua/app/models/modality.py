from typing import List
from sqlalchemy import SmallInteger

from sqlalchemy.orm import relationship, Mapped, mapped_column

from app.db.base_class import Base, BaseEnum
from app.schemas.modality import TypeEnum, FrameEnum, SportEnum

# Needs to be done this way because of circular dependencies
import app.models.competition
import app.models.team


class Modality(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    year: Mapped[int] = mapped_column(SmallInteger, index=True)
    type: Mapped[TypeEnum] = mapped_column(BaseEnum(TypeEnum))
    frame: Mapped[TypeEnum] = mapped_column(BaseEnum(FrameEnum))
    sport: Mapped[TypeEnum] = mapped_column(BaseEnum(SportEnum))

    competitions: Mapped[List["app.models.competition.Competition"]] = relationship(
        "Competition",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
    teams: Mapped[List["app.models.team.Team"]] = relationship(
        "app.models.team.Team",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
