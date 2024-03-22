from datetime import datetime
from typing import Optional

from sqlalchemy import String, ForeignKey, Enum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.news import CategoryEnum
from app.models.user import User


class News(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    author_id: Mapped[int] = mapped_column(
        ForeignKey(User.id, name="fk_author_id"),
        index=True,
    )
    category: Mapped[CategoryEnum] = mapped_column(
        Enum(CategoryEnum, name="category_enum", inherit_schema=True)
    )
    _header: Mapped[Optional[str]] = mapped_column("header", String(2048))
    title: Mapped[str] = mapped_column(String(256))
    content: Mapped[Optional[str]] = mapped_column(String(20000))
    created_at: Mapped[datetime]
    updated_at: Mapped[datetime]

    author: Mapped[User] = relationship(User, foreign_keys=[author_id])

    public: Mapped[bool] = mapped_column(default=False)

    @hybrid_property
    def header(self) -> Optional[str]:
        return self._header and settings.STATIC_URL + self._header

    @header.setter
    def header(self, header: Optional[str]):
        self._header = header
