from sqlalchemy import Column, Integer, String, SmallInteger, ForeignKey

from app.db.base_class import Base
from app.core.config import settings


class Subject(Base):
    code = Column(Integer, primary_key=True, autoincrement=False)
    course_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + '.course.code'))
    curricular_year = Column(Integer, nullable=False)
    name = Column(String(128), nullable=False)
    short = Column(String(8), nullable=False)
    semester = Column(Integer)
    discontinued = Column(SmallInteger)
    optional = Column(SmallInteger)
