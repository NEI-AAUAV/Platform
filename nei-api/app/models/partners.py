from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import DateTime, String, Text, Column, Integer
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Partners(Base):
    __tablename__ = "partners"

    id = Column(Integer, primary_key=True, autoincrement=True)
    _header = Column("header", String(2048))
    company = Column(String(255))
    description = Column(Text)
    content = Column(String(255))
    link = Column(String(255))
    banner_url = Column(String(255))
    _banner_image = Column("banner_image", String(2048))
    banner_until = Column(DateTime)

    @hybrid_property
    def header(self) -> Optional[AnyHttpUrl]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[AnyHttpUrl]):
        self._header = header

    @hybrid_property
    def banner_image(self) -> Optional[AnyHttpUrl]:
        return self._banner_image and settings.STATIC_URL + self._banner_image

    @banner_image.setter
    def banner_image(self, banner_image: Optional[AnyHttpUrl]):
        self._banner_image = banner_image
