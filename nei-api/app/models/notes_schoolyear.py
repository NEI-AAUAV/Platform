from sqlalchemy import Column, Integer, SmallInteger

from app.db.base_class import Base


class NotesSchoolYear(Base):
    __tablename__ = "notes_school_year"

    id = Column(Integer, primary_key=True, autoincrement=True)
    year_begin = Column(SmallInteger)
    year_end = Column(SmallInteger)
