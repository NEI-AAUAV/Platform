from sqlalchemy import Column, Integer, String, Boolean, ForeignKey

from app.db.base_class import Base
from app.core.config import settings


class Subject(Base):
    code = Column(Integer, primary_key=True, autoincrement=False)
    public = Column(Boolean, default=False)
    curricular_year = Column(Integer)
    name = Column(String(128), nullable=False)
    short = Column(String(8))
    link = Column(String(2048))
