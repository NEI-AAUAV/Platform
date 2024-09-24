from typing import List, Optional

from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import relationship, mapped_column, Mapped
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.core.config import settings

# Needs to be done this way because of circular dependencies
import app.models.participant
import app.models.course


class Team(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    course_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.course.id"), index=True
    )
    modality_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.modality.id", ondelete="CASCADE"),
        index=True,
    )
    name: Mapped[Optional[str]] = mapped_column(String(50))
    # desclassified: Mapped[bool] = mapped_column(default=False)  # TODO: future feature
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))

    participants: Mapped[List["app.models.participant.Participant"]] = relationship(
        "app.models.participant.Participant",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
    course: Mapped[List["app.models.course.Course"]] = relationship(
        "app.models.course.Course", lazy="joined"
    )

    @hybrid_property
    def image(self) -> Optional[str]:
        return self._image and settings.STATIC_URL + self._image

    @image.expression
    def image(cls) -> Optional[str]:
        return cls._image

    @image.setter
    def image(self, image: Optional[str]):
        self._image = image
