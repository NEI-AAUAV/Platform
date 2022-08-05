from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class Notes(Base):
    __tablename__ = "notes"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    location = Column(String(255))
    subject_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".notes_subject.paco_code", name="fk_subject_id"), index=True)
    author_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_author_id"), index=True)
    school_year_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".notes_school_year.id", name="fk_school_year_id"), index=True)
    teacher_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".notes_teachers.id", name="fk_teacher_id"), index=True)
    summary = Column(SmallInteger)
    tests = Column(SmallInteger)
    bibliography = Column(SmallInteger)
    slides = Column(SmallInteger)
    exercises = Column(SmallInteger)
    projects = Column(SmallInteger)
    notebook = Column(SmallInteger)
    content = Column(Text)
    createdAt = Column(DateTime, index=True)
    type_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".notes_types.id", name="fk_type_id"), index=True)
    size = Column(Integer)

    subject = relationship("NotesSubject", foreign_keys=[subject_id])
    author = relationship("Users", foreign_keys=[author_id])
    school_year = relationship("NotesSchoolYear", foreign_keys=[school_year_id])
    teacher = relationship("NotesTeachers", foreign_keys=[teacher_id])
    type = relationship("NotesTypes", foreign_keys=[type_id])
