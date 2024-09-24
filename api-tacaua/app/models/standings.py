from typing import List

from sqlalchemy import ARRAY, SmallInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base_class import Base

from app.models.team import Team
from app.models.group import Group


class Standings(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    team_id: Mapped[int] = mapped_column(ForeignKey(Team.id, ondelete="CASCADE"))
    group_id: Mapped[int] = mapped_column(ForeignKey(Group.id, ondelete="CASCADE"))
    pts: Mapped[int] = mapped_column(SmallInteger, default=0)
    matches: Mapped[int] = mapped_column(SmallInteger, default=0)
    wins: Mapped[int] = mapped_column(SmallInteger, default=0)
    ties: Mapped[int] = mapped_column(SmallInteger, default=0)
    losses: Mapped[int] = mapped_column(SmallInteger, default=0)
    ff: Mapped[int] = mapped_column(SmallInteger, default=0)
    score_for: Mapped[int] = mapped_column(SmallInteger, default=0)
    score_agst: Mapped[int] = mapped_column(SmallInteger, default=0)
    goal_difference: Mapped[int] = mapped_column(SmallInteger, default=0)
    match_history: Mapped[List[int]] = mapped_column(ARRAY(SmallInteger), default=[])

    team: Mapped[Team] = relationship(lazy="joined")
