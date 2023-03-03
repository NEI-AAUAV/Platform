from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Senior(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    year = Column(Integer)
    course = Column(String(6))
    _image = Column("image", String(2048))

    students = relationship("SeniorStudent")

    __table_args__ = (
        UniqueConstraint('year', 'course', name='uc_year_course'),
        {"schema": settings.SCHEMA_NAME}
    )

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
