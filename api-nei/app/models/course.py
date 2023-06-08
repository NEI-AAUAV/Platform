from sqlalchemy import Boolean, Column, Integer, String, SmallInteger

from app.db.base_class import Base


class Course(Base):
    code = Column(Integer, primary_key=True, autoincrement=False)
    public = Column(Boolean, default=False)
    name = Column(String(128), nullable=False)
    short = Column(String(8))
