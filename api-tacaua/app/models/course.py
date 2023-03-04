from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.core.config import settings


class Course(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(60), nullable=False)
    short = Column(String(16), nullable=False)
    color = Column(String(30), default="white")
    _image = Column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
