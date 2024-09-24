from typing import Optional
from sqlalchemy import String, ForeignKey
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base

from app.core.config import settings


class Participant(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    team_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.team.id", ondelete="CASCADE"),
        index=True,
    )
    name: Mapped[str] = mapped_column(String(50))
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.expression
    def image(cls) -> Optional[str]:
        return cls._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
