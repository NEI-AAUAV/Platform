from sqlalchemy import Column, ARRAY, SmallInteger, Integer, ForeignKey

from app.db.base_class import Base

from app.models.team import Team
from app.models.group import Group


class Standings(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    team = Column(
        Integer,
        ForeignKey(Team.id, ondelete="CASCADE"),
        nullable=False
    )
    group = Column(
        Integer,
        ForeignKey(Group.id, ondelete="CASCADE"),
        nullable=False
    )
    pts = Column(SmallInteger, default=0)
    matches = Column(SmallInteger, default=0)
    wins = Column(SmallInteger, default=0)
    ties = Column(SmallInteger, default=0)
    losses = Column(SmallInteger, default=0)
    ff = Column(SmallInteger, default=0)
    score_for = Column(SmallInteger, default=0)
    score_agst = Column(SmallInteger, default=0)
    math_history = Column(ARRAY(SmallInteger), default=[])
