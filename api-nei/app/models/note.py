from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Note(Base):
    __tablename__ = "note"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    _location = Column("location", String(2048))

    subject_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".note_subject.paco_code", name="fk_subject_id"), index=True)
    author_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".user.id", name="fk_author_id"), index=True)
    school_year_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".note_school_year.id", name="fk_school_year_id"), index=True)
    teacher_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".note_teacher.id", name="fk_teacher_id"), index=True)
    
    summary = Column(SmallInteger)
    tests = Column(SmallInteger)
    bibliography = Column(SmallInteger)
    slides = Column(SmallInteger)
    exercises = Column(SmallInteger)
    projects = Column(SmallInteger)
    notebook = Column(SmallInteger)

    content = Column(Text)
    created_at = Column(DateTime, index=True)
    type_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".note_type.id", name="fk_type_id"), index=True)
    size = Column(Integer)

    subject = relationship("NoteSubject", foreign_keys=[subject_id])
    author = relationship("User", foreign_keys=[author_id])
    school_year = relationship("NoteSchoolYear", foreign_keys=[school_year_id])
    teacher = relationship("NoteTeacher", foreign_keys=[teacher_id])
    type = relationship("NoteType", foreign_keys=[type_id])

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
