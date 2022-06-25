from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class TacaUAModality(Base):
    __tablename__ = "tacaua_modality"

    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_details_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".tacaua_modality_details.id"))
    year = Column(SmallInteger, index=True)
    division = Column(SmallInteger)
    division_group = Column(String(5), nullable=True)
    image_url = Column(Text, nullable=True)

    modality_details = relationship("TacaUAModalityDetails")
