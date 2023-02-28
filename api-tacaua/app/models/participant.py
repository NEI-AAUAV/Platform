from typing import Optional
from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.ext.hybrid import hybrid_property

from app.db.base_class import Base

from app.core.config import settings


class Participant(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    team_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".team.id", ondelete='CASCADE'),
        nullable=False,
        index=True
    )
    name = Column(String(50), nullable=False)
    _image = Column("image", String(2048))

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image
