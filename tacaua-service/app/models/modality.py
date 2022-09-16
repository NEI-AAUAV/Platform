from sqlalchemy import Column, SmallInteger, Integer, Text, Enum
from sqlalchemy.orm import relationship

from app.db.base_class import Base
from app.schemas.modality import FrameEnum, SportEnum


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
