from sqlalchemy import Column, Enum, SmallInteger, Integer, String

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.tacaua_modality_details import TypeEnum, GenderEnum
from pydantic.color import Color

class TacaUAModalityDetails(Base):
    __tablename__ = "tacaua_modality_details"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(30))
    color = Column(Color)
    type = Column(Enum(TypeEnum, name="type_enum", create_type=False))
    gender = Column(Enum(GenderEnum, name="gender_enum", create_type=False))
    pts_win = Column(SmallInteger, default=0)
    pts_draw = Column(SmallInteger, default=0)
    pts_loss = Column(SmallInteger, default=0)
    pts_forfeit = Column(SmallInteger, default=0)
    ff_scored_for = Column(SmallInteger, default=0)
    ff_scored_agst = Column(SmallInteger, default=0)
