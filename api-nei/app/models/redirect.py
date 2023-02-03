from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base

class Redirect(Base):
    __tablename__ = "redirect"

    id = Column(Integer, primary_key=True, autoincrement=True)
    alias = Column(String(255))
    _redirect = Column("redirect", String(2048))

    @hybrid_property
    def redirect(self) -> Optional[AnyHttpUrl]:
        return self._redirect

    @redirect.setter
    def redirect(self, redirect: Optional[AnyHttpUrl]):
        self._redirect = redirect
