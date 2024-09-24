from typing import Optional

from sqlalchemy import String
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base
from app.core.config import settings


class Course(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(60))
    short: Mapped[str] = mapped_column(String(16))
    color: Mapped[Optional[str]] = mapped_column(String(30), default="white")
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.expression
    def image(cls) -> Optional[str]:
        return cls._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
