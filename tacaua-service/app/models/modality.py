from pathlib import Path
from pydantic import AnyHttpUrl
from sqlalchemy import Column, SmallInteger, Integer, Text, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.schemas.modality import FrameEnum, SportEnum
from app.core.config import settings
from app.core.logging import logger


class Modality(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(SmallInteger, nullable=False, index=True)
    frame = Column(
        Enum(FrameEnum, name="frame_enum", inherit_schema=True),
        nullable=False
    )
    sport = Column(
        Enum(SportEnum, name="sport_enum", inherit_schema=True),
        nullable=False
    )
    image = Column(Text)

    competitions = relationship(
        "Competition",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )
    teams = relationship(
        "Team",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )

    @hybrid_property
    def image(self) -> AnyHttpUrl:
        return settings.STATIC_URL + self._image

    @image.setter
    def image(self, value: Path):
        self._image = value
