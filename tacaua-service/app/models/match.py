from sqlalchemy import Column, Boolean, SmallInteger, Integer, DateTime, ForeignKey, ForeignKeyConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.db.base_class import Base


class Match(Base):
    id = Column(Integer, primary_key=True)
    round_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".round.id", ondelete='CASCADE'),
        index=True
    )
    team1_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id",
                   ondelete='SET NULL',
                   name="match_team1_id_fkey"),
        index=True
    )
    team2_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id",
                   ondelete='SET NULL',
                   name="match_team2_id_fkey"),
        index=True
    )
    score1 = Column(SmallInteger)
    score2 = Column(SmallInteger)
    games1 = Column(ARRAY(SmallInteger), default=[])
    games2 = Column(ARRAY(SmallInteger), default=[])
    winner = Column(SmallInteger)   # TODO:
    forfeiter = Column(SmallInteger)    # TODO:
    live = Column(Boolean, default=False)   # TODO:
    date = Column(DateTime, index=True)
    team1_prereq_match_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id",  # TODO: needs ondelete for when round deletes??
                   name="match_team1_prereq_match_id_fkey"),
        index=True
    )
    team2_prereq_match_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id",
                   name="match_team2_prereq_match_id_fkey"),
        index=True
    )
    # team1_placeholder_text = Column(String) computed
    team1_is_prereq_match_winner = Column(Boolean, default=True)
    team2_is_prereq_match_winner = Column(Boolean, default=True)

    team1 = relationship("Team", foreign_keys=[team1_id])
    team2 = relationship("Team", foreign_keys=[team2_id])


# TODO:
#  Bank = relationship("Banks", uselist=False)
#
# ForeignKey("Banks.IdBank", ondelete="CASCADE"),
# nullable=False

# ondelete= 'CASCADE', 'SET NULL', 'SET DEFAULT'
# onupdate
# min max
