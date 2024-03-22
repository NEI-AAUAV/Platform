from typing import Optional, List

from pydantic import AnyHttpUrl
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from .faina_member import FainaMember


class Faina(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    mandate: Mapped[str] = mapped_column(String(7))

    members: Mapped[List[FainaMember]] = relationship(FainaMember)

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
