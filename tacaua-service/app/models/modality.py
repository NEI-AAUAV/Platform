from typing import Optional
from pydantic import AnyHttpUrl
from sqlalchemy import Column, SmallInteger, Integer, String, Enum
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
    _image = Column("image", String(2048))

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
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
