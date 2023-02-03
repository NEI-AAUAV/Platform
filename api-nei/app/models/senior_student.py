from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class SeniorStudent(Base):
    __tablename__ = "senior_student"

    senior_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".senior.id"), primary_key=True)
    user_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".user.id"), primary_key=True)
    quote = Column(String(280))
    _image = Column("image", String(2048))

    user = relationship("User")

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
