from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import String, Column, Integer
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Rgm(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    category = Column(String(11))
    mandate = Column(String(7), default=0)
    _file = Column("file", String(2048))

    @hybrid_property
    def file(self) -> Optional[AnyHttpUrl]:
        return self._file and settings.STATIC_URL + self._file

    @file.setter
    def file(self, file: Optional[AnyHttpUrl]):
        self._file = file
