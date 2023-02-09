from sqlalchemy import Column, String, Integer

from app.db.base_class import Base


class NoteTeacher(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))
    personal_page = Column(String(256))
