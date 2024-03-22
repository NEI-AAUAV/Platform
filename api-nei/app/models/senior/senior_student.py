from typing import Optional

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User


class SeniorStudent(Base):
    senior_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.senior.id"), primary_key=True
    )
    user_id: Mapped[int] = mapped_column(ForeignKey(User.id), primary_key=True)
    quote: Mapped[Optional[str]] = mapped_column(String(280))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    user: Mapped[User] = relationship(User)

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.expression
    def image(cls) -> Optional[str]:
        return cls._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
