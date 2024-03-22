from datetime import datetime
from typing import Optional

from sqlalchemy import Date, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class History(Base):
    moment: Mapped[datetime] = mapped_column(Date, primary_key=True)
    title: Mapped[str] = mapped_column(String(120))
    body: Mapped[Optional[str]] = mapped_column(Text)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
