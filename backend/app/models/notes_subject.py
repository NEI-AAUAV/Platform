from sqlalchemy import Column, Integer, String, SmallInteger

from app.db.base_class import Base


class NotesSubject(Base):
    __tablename__ = "notes_subject"

    paco_code = Column(Integer, primary_key=True)
    name = Column(String(60))
    year = Column(Integer)
    semester = Column(Integer)
    short = Column(String(5))
    discontinued = Column(SmallInteger)
    optional = Column(SmallInteger)
