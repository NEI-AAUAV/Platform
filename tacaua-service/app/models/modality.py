from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey, Enum
from sqlalchemy.orm import relationship

from app.db.base_class import Base
from app.schemas.modality import FrameEnum, SportEnum


class Modality(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(SmallInteger, nullable=False, index=True)
    frame = Column(Enum(FrameEnum, name="frame_enum", inherit_schema=False),
                   nullable=False)
    sport = Column(Enum(SportEnum, name="sport_enum", inherit_schema=False),
                   nullable=False)
    image = Column(Text)

    competitions = relationship(
        "Competition",
        cascade="all, delete",
        passive_deletes=True,
    )
