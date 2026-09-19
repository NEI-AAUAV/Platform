import uuid
from typing import Optional

from sqlalchemy import CheckConstraint, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, declared_attr, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Merch(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(256))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    # Uploaded via nei-directus; additive, nullable, preferred over `_image`
    # when set (see alembic migration d7e9f1a3b5c7).
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    discontinued: Mapped[bool] = mapped_column(default=False, server_default="false")
    price: Mapped[Optional[float]] = mapped_column(default=0)
    number_of_items: Mapped[Optional[int]] = mapped_column(default=0)

    @declared_attr.directive
    def __table_args__(cls):
        return (
            CheckConstraint("price >= 0", name="price_non_negative"),
            CheckConstraint("number_of_items >= 0", name="number_of_items_non_negative"),
            Base.__table_args__,
        )

    @hybrid_property
    def image(self) -> Optional[str]:
        if self.image_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.image_asset}"
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
