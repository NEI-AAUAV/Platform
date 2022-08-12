from sqlalchemy import Column, String, Integer

from app.db.base_class import Base


class NotesTeachers(Base):
    __tablename__ = "notes_teachers"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))
    personalPage = Column(String(255))
