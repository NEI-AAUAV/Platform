from pathlib import Path
from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, Text, ForeignKey, SmallInteger
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base
from app.core.config import settings


class Team(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete='CASCADE'),
        index=True
    )
    name = Column(String(50))
    # desclassified = Column(Boolean, default=False)  # TODO: future feature
    image = Column(Text)

    participants = relationship(
        "Participant",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )

    @hybrid_property
    def image(self) -> AnyHttpUrl:
        return settings.STATIC_URL + self._image

    @image.setter
    def image(self, value: Path):
        self._image = value
