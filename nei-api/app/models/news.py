from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.news import StatusEnum, CategoryEnum


class News(Base):
    __tablename__ = "news"

    id = Column(Integer, primary_key=True, autoincrement=True)
    _header = Column("header", String(2048))
    status = Column(Enum(StatusEnum, name="status_enum", inherit_schema=True))
    title = Column(String(255))
    category = Column(Enum(CategoryEnum, name="category_enum", inherit_schema=True))
    content = Column(String(20000))
    published_by = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_publisher_id"), index=True)
    created_at = Column(DateTime)
    last_change_at = Column(DateTime)
    changed_by = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_editor_id"), index=True)
    author_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_author_id"), index=True)

    publisher = relationship("Users", foreign_keys=[published_by])
    editor = relationship("Users", foreign_keys=[changed_by])
    author = relationship("Users", foreign_keys=[author_id])

    @hybrid_property
    def header(self) -> Optional[AnyHttpUrl]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[AnyHttpUrl]):
        self._header = header  
