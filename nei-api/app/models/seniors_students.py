from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, ForeignKey, Integer, String, ForeignKeyConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declared_attr
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class SeniorsStudents(Base):
    __tablename__ = "seniors_students"

    @declared_attr
    def __table_args__(cls) -> dict:
        return (ForeignKeyConstraint(
            ['year', 'course'],
            [settings.SCHEMA_NAME + '.seniors.year', settings.SCHEMA_NAME + '.seniors.course']
        ),{"schema": settings.SCHEMA_NAME})

    year = Column(Integer, primary_key=True)
    course = Column(String(3), primary_key=True)
    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id"), primary_key=True)
    quote = Column(String(280))
    _image = Column("image", String(2048))

    #year = relationship("Seniors", foreign_keys=[year_id])
    #course = relationship("Seniors", foreign_keys=[course])
    user = relationship("Users", foreign_keys=[user_id])

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
