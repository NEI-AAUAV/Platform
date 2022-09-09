from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Competition(Base):
    __tablename__ = "competition"

    id = Column(Integer, primary_key=True, autoincrement=True)

    # pts_win = Column(SmallInteger, default=0)
    # pts_win_tiebreak = Column(SmallInteger, default=0)
    # pts_tie = Column(SmallInteger, default=0)
    # pts_loss_tiebreak = Column(SmallInteger, default=0)
    # pts_loss = Column(SmallInteger, default=0)
    # pts_ff = Column(SmallInteger, default=0)
    # ff_scored_for = Column(SmallInteger, default=0)
    # ff_scored_agst = Column(SmallInteger, default=0)
