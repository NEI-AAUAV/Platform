import uuid
from datetime import date
from typing import Optional

from sqlalchemy import BigInteger, Date, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class History(Base):
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    moment: Mapped[date] = mapped_column(Date, index=True)
    title: Mapped[str] = mapped_column(String(120))
    body: Mapped[Optional[str]] = mapped_column(Text)
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    # Uploaded via nei-directus; additive, nullable.
    image_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))

    @hybrid_property
    def image(self) -> Optional[str]:
        if self.image_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.image_asset}"
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
