from sqlalchemy import Column, SmallInteger, Integer, String, Text, ForeignKey

from app.db.base_class import Base


class Modality(Base):
    __tablename__ = "modality"

    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(SmallInteger, index=True)
    division = Column(SmallInteger)
    group = Column(String(5), nullable=True)
    image = Column(Text, nullable=True)
