from typing import Optional
from pydantic import AnyHttpUrl
from sqlalchemy import Column, Boolean, SmallInteger, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.schemas.modality import TypeEnum, FrameEnum, SportEnum
from app.core.config import settings
from app.core.logging import logger

from app.models.team import Team


class Standings(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    team = Column(
        String(50),
        ForeignKey(Team.id, ondelete="CASCADE"),
        nullable=False
    )
    pts = Column(SmallInteger, default=0)
    wins = Column(SmallInteger, default=0)
    ties = Column(SmallInteger, default=0)
    losses = Column(SmallInteger, default=0)
    goals_scored = Column(SmallInteger, default=0)
    goals_against = Column(SmallInteger, default=0)
    goal_difference = Column(SmallInteger, default=0)

    classification = Column(Integer, nullable=False)
    has_passed = Column(Boolean, default=False)
    

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
