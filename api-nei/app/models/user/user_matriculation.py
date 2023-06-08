from sqlalchemy import ARRAY, Table, Column, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class UserMatriculation(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".user.id"),
        nullable=False,
        index=True)
    course_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".course.code"),
        nullable=False,
        index=True)
    subject_ids = Column(ARRAY(Integer), nullable=False)
    curricular_year = Column(Integer, nullable=False)
    created_at = Column(DateTime, nullable=False, index=True)
