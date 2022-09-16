from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String, ForeignKeyConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declared_attr

from app.core.config import settings
from app.db.base_class import Base


class SeniorsStudents(Base):
    __tablename__ = "seniors_students"

    @declared_attr
    def __table_args__(cls) -> dict:
        return (ForeignKeyConstraint(
            ['year_id', 'course_name'],
            [settings.SCHEMA_NAME + '.seniors.year', settings.SCHEMA_NAME + '.seniors.course']
        ),{"schema": settings.SCHEMA_NAME})

    year_id = Column(Integer, primary_key=True)
    course_name = Column(String(3), primary_key=True)
    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id"), primary_key=True)
    quote = Column(String(280))
    image = Column(String(255))    

    
    year = relationship("Seniors", foreign_keys=[year_id])
    course = relationship("Seniors", foreign_keys=[course_name])
    user = relationship("Users", foreign_keys=[user_id])
