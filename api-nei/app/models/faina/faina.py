import uuid
from typing import Optional, List

from pydantic import AnyHttpUrl
from sqlalchemy import String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from .faina_member import FainaMember


class Faina(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    mandate: Mapped[str] = mapped_column(String(7))
    # Uploaded via nei-directus; additive, nullable (see alembic migration
    # a4b6c8d0e2f4). Preferred over `_image` when set.
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))

    members: Mapped[List[FainaMember]] = relationship(FainaMember)

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        if self.image_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.image_asset}"
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
