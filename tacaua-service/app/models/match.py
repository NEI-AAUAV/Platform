from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey, ForeignKeyConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.db.base_class import Base


class Match(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    round_id = Column(Integer, index=True)
    team1_id = Column(Integer, index=True)
    team2_id = Column(Integer, index=True)
    score1 = Column(SmallInteger, default=0)
    score2 = Column(SmallInteger, default=0)
    games_scores1 = Column(ARRAY(SmallInteger), default=[])
    games_scores2 = Column(ARRAY(SmallInteger), default=[])
    team1_prereq_match_id = Column(Integer, index=True)
    team2_prereq_match_id = Column(Integer, index=True)
    date = Column(DateTime, index=True)

    team1 = relationship("Team", foreign_keys=[team1_id])
    team2 = relationship("Team", foreign_keys=[team2_id])

    __table_args__ = (
        *super().__table_args__,
        ForeignKeyConstraint([round_id],
                             [settings.SCHEMA_NAME + ".round.id"]),
        ForeignKeyConstraint([team1_id, team2_id],
                             [settings.SCHEMA_NAME + ".team.id"]),
        ForeignKeyConstraint([team1_prereq_match_id, team2_prereq_match_id],
                             [settings.SCHEMA_NAME + ".match.id"]),
    )


# TODO:
#  Bank = relationship("Banks", uselist=False)
#
# ForeignKey("Banks.IdBank", ondelete="CASCADE"),
# nullable=False

# ondelete= 'CASCADE', 'SET NULL', 'SET DEFAULT'
# onupdate
