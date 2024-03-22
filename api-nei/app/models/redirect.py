from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Redirect(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    alias: Mapped[str] = mapped_column(String(256))
    _redirect: Mapped[str] = mapped_column("redirect", String(2048))

    @hybrid_property
    def redirect(self) -> str:
        return settings.STATIC_URL + self._redirect

    @redirect.setter
    def redirect(self, redirect: str):
        self._redirect = redirect
