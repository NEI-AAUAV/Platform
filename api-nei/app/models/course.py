from sqlalchemy import Column, Integer, String, SmallInteger

from app.db.base_class import Base


class Course(Base):
    code = Column(Integer, primary_key=True, autoincrement=False)
    name = Column(String(128), nullable=False)
    short = Column(String(8), nullable=False)
    discontinued = Column(SmallInteger)
