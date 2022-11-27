from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Date, String, Text, Column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class History(Base):
    __tablename__ = "history"

    moment = Column(Date, primary_key=True)
    title = Column(String(120))
    body = Column(Text)
    _image = Column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
