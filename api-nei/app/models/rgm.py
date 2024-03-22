from datetime import datetime
from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Rgm(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    category: Mapped[str] = mapped_column(String(3))
    mandate: Mapped[str] = mapped_column(String(7), index=True)
    date: Mapped[datetime]
    title: Mapped[str] = mapped_column(String(264))
    _file: Mapped[str] = mapped_column("file", String(2048))

    @hybrid_property
    def file(self) -> str:
        return settings.STATIC_URL + self._file

    @file.setter
    def file(self, file: str):
        self._file = file
