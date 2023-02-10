from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Note(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    author_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".user.id", name="fk_author_id"),
        index=True)
    subject_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".subject.code",
                   name="fk_subject_id"),
        index=True)
    teacher_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".teacher.id",
                   name="fk_teacher_id"),
        index=True)
    
    name = Column(String(256))
    _location = Column("location", String(2048))
    year = Column(SmallInteger, nullable=False, index=True)

    summary = Column(SmallInteger)
    tests = Column(SmallInteger)
    bibliography = Column(SmallInteger)
    slides = Column(SmallInteger)
    exercises = Column(SmallInteger)
    projects = Column(SmallInteger)
    notebook = Column(SmallInteger)

    content = Column(Text)
    created_at = Column(DateTime, index=True)
    size = Column(Integer)

    author = relationship("User", foreign_keys=[author_id])
    subject = relationship("Subject", foreign_keys=[subject_id])
    teacher = relationship("Teacher", foreign_keys=[teacher_id])

    @hybrid_property
    def location(self) -> Optional[AnyHttpUrl]:
        if not self._location:
            return None
        if str(self._location).startswith('/'):
            return settings.STATIC_URL + self._location
        return self._location

    @location.setter
    def location(self, location: Optional[AnyHttpUrl]):
        self._location = location
