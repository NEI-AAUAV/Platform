from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.core.config import settings


class Team(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    course_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".course.id"),
        index=True
    )
    modality_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete='CASCADE'),
        nullable=False,
        index=True
    )
    name = Column(String(50))
    # desclassified = Column(Boolean, default=False)  # TODO: future feature
    _image = Column("image", String(2048))

    participants = relationship(
        "Participant",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )
    course = relationship("Course", lazy='joined')

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
