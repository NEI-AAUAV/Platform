from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Float, String, Column, Integer
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Merchandisings(Base):
    __tablename__ = "merchandisings"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    _image = Column("image", String(2048))
    price = Column(Float, default=0)
    number_of_items = Column(Integer, default=0)

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
