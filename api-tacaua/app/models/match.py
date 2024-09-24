from datetime import datetime
from typing import List, Optional

from sqlalchemy import SmallInteger, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.db.base_class import Base

# Needs to be done this way because of circular dependencies
import app.models.group
import app.models.team


class Match(Base):
    id: Mapped[int] = mapped_column(primary_key=True)
    round: Mapped[int] = mapped_column(SmallInteger)
    group_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.group.id", ondelete="CASCADE"),
        index=True,
    )
    team1_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(
            f"{settings.SCHEMA_NAME}.team.id",
            ondelete="SET NULL",
            name="match_team1_id_fkey",
        ),
        index=True,
    )
    team2_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(
            f"{settings.SCHEMA_NAME}.team.id",
            ondelete="SET NULL",
            name="match_team2_id_fkey",
        ),
        index=True,
    )
    score1: Mapped[Optional[int]] = mapped_column(SmallInteger)
    score2: Mapped[Optional[int]] = mapped_column(SmallInteger)
    games1: Mapped[List[int]] = mapped_column(ARRAY(SmallInteger), default=[])
    games2: Mapped[List[int]] = mapped_column(ARRAY(SmallInteger), default=[])
    winner: Mapped[Optional[int]] = mapped_column(SmallInteger)
    forfeiter: Mapped[Optional[int]] = mapped_column(SmallInteger)
    live: Mapped[Optional[bool]] = mapped_column(default=False)
    date: Mapped[Optional[datetime]] = mapped_column(index=True)
    team1_prereq_match_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(
            id,  # TODO: needs ondelete for when round deletes??
            ondelete="SET NULL",
            name="match_team1_prereq_match_id_fkey",
        ),
        index=True,
    )
    team2_prereq_match_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(
            id,
            ondelete="SET NULL",
            name="match_team2_prereq_match_id_fkey",
        ),
        index=True,
    )
    # team1_placeholder_text = Column(String) computed
    team1_is_prereq_match_winner: Mapped[Optional[bool]] = mapped_column(default=True)
    team2_is_prereq_match_winner: Mapped[Optional[bool]] = mapped_column(default=True)

    team1: Mapped[List["app.models.team.Team"]] = relationship(
        "app.models.team.Team", foreign_keys=[team1_id]
    )
    team2: Mapped[List["app.models.team.Team"]] = relationship(
        "app.models.team.Team", foreign_keys=[team2_id]
    )


# TODO:
#  Bank = relationship("Banks", uselist=False)
#
# ForeignKey("Banks.IdBank", ondelete="CASCADE"),
# nullable=False

# ondelete= 'CASCADE', 'SET NULL', 'SET DEFAULT'
# onupdate
# min max
