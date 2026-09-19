import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import String, Integer, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.assets import asset_url
from app.core.config import settings
from app.db.base_class import Base


class Partner(Base):
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    _header: Mapped[Optional[str]] = mapped_column("header", String(2048))
    # Uploaded via nei-directus; additive, nullable, preferred over
    # `_header`/`_banner_image` when set (see alembic migration
    # d7e9f1a3b5c7).
    header_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    company: Mapped[str] = mapped_column(String(256))
    description: Mapped[Optional[str]] = mapped_column(Text)
    content: Mapped[Optional[str]] = mapped_column(String(256))
    link: Mapped[Optional[str]] = mapped_column(String(256))
    banner_url: Mapped[Optional[str]] = mapped_column(String(256))
    _banner_image: Mapped[Optional[str]] = mapped_column("banner_image", String(2048))
    banner_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    banner_until: Mapped[Optional[datetime]]

    @hybrid_property
    def header(self) -> Optional[str]:
        if self.header_asset:
            return asset_url(self.header_asset)
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[str]):
        self._header = header

    @hybrid_property
    def banner_image(self) -> Optional[str]:
        if self.banner_asset:
            return asset_url(self.banner_asset)
        return self._banner_image and settings.STATIC_URL + self._banner_image

    @banner_image.setter
    def banner_image(self, banner_image: Optional[str]):
        self._banner_image = banner_image
