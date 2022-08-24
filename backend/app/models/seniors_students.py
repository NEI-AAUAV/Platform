from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class SeniorsStudents(Base):
    __tablename__ = "seniors_students"

    #year_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".seniors.year"), primary_key=True)
    #course_id = Column(String(3), ForeignKey(settings.SCHEMA_NAME + ".seniors.course"), primary_key=True)
    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id"), primary_key=True)
    quote = Column(String(280))
    image = Column(String(255))

    #year = relationship("Seniors", foreign_keys=[year_id])
    #course = relationship("Seniors", foreign_keys=[course_id])
    user = relationship("Users", foreign_keys=[user_id])
