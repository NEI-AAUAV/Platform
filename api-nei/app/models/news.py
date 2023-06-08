from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Boolean, Column, String, Integer, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.news import CategoryEnum


class News(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    author_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".user.id", name="fk_author_id"),
        index=True)
    public = Column(Boolean, default=False)
    category = Column(
        Enum(CategoryEnum, name="category_enum", inherit_schema=True))
    _header = Column("header", String(2048))
    title = Column(String(256))
    content = Column(String(20000))
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    author = relationship("User", foreign_keys=[author_id])

    @hybrid_property
    def header(self) -> Optional[AnyHttpUrl]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[AnyHttpUrl]):
        self._header = header
