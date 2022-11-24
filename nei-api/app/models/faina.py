from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Faina(Base):
    __tablename__ = "faina"

    id = Column(Integer, primary_key=True, autoincrement=True)
    _image = Column("image", String(2048))
    year = Column(String(9))

    members = relationship(
        "FainaMember",
    )

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image  
