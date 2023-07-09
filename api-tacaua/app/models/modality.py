from sqlalchemy import Column, SmallInteger, Integer
from sqlalchemy.orm import relationship

from app.db.base_class import Base, BaseEnum
from app.schemas.modality import TypeEnum, FrameEnum, SportEnum


class Modality(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(SmallInteger, nullable=False, index=True)
    type = Column(BaseEnum(TypeEnum), nullable=False)
    frame = Column(BaseEnum(FrameEnum), nullable=False)
    sport = Column(BaseEnum(SportEnum), nullable=False)

    competitions = relationship(
        "Competition",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
    teams = relationship(
        "Team",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
