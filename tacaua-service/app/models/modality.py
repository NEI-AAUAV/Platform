from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey, Enum

from app.db.base_class import Base
from app.schemas.modality import FrameEnum, SportEnum


class Modality(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(SmallInteger, index=True)
    group = Column(String(5), nullable=True)
    image = Column(Text, nullable=True)
    frame = Column(Enum(FrameEnum, name="frame_enum", create_type=False))
    sport = Column(Enum(SportEnum, name="sport_enum", create_type=False))

