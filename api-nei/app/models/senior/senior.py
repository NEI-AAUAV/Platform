from typing import Optional, List

from sqlalchemy import String, UniqueConstraint
from sqlalchemy.orm import relationship, Mapped, mapped_column, declared_attr
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from .senior_student import SeniorStudent


class Senior(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    year: Mapped[int]
    course: Mapped[str] = mapped_column(String(6))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    students: Mapped[List[SeniorStudent]] = relationship(SeniorStudent)

    @declared_attr.directive
    def __table_args__(cls):
        return (
            UniqueConstraint("year", "course", name="uc_year_course"),
            Base.__table_args__,
        )

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.expression
    def image(self) -> Optional[str]:
        return self._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
