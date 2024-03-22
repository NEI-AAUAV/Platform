from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Merch(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(256))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    discontinued: Mapped[bool]
    price: Mapped[Optional[float]] = mapped_column(default=0)
    number_of_items: Mapped[Optional[int]] = mapped_column(default=0)

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
