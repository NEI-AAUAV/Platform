from sqlalchemy import Table, Column, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


user_academic_details__subjects = Table(
    "user_academic_details__subjects",
    Base.metadata,
    Column("user_academic_details_id",
           ForeignKey(settings.SCHEMA_NAME + ".user_academic_details.id"),
           primary_key=True),
    Column("subject",
           ForeignKey(settings.SCHEMA_NAME + ".subject.code"),
           primary_key=True),
    schema=settings.SCHEMA_NAME,
)


class UserAcademicDetails(Base):
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
    curricular_year = Column(Integer, nullable=False)
    created_at = Column(DateTime, nullable=False, index=True)

    subjects = relationship(
        "Subject", secondary=user_academic_details__subjects)
