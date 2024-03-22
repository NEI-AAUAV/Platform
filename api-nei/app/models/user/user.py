from datetime import datetime
from typing import Optional, List

from pydantic import AnyHttpUrl
from sqlalchemy import String, Enum, Text, Date, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.ext.mutable import MutableList
from sqlalchemy.dialects.postgresql import ARRAY

from app.db.base_class import Base
from app.core.config import settings
from app.schemas.user import GenderEnum
from .user_matriculation import UserMatriculation


class User(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    iupi: Mapped[Optional[str]] = mapped_column(String(36), unique=True)
    nmec: Mapped[Optional[int]] = mapped_column(unique=True)
    hashed_password: Mapped[Optional[str]] = mapped_column(Text)
    name: Mapped[str] = mapped_column(String(20))
    surname: Mapped[str] = mapped_column(String(20))
    gender: Mapped[Optional[GenderEnum]] = mapped_column(
        Enum(GenderEnum, name="gender_enum", inherit_schema=True)
    )
    _image: Mapped[Optional[str]] = mapped_column("image", String(2048))
    _curriculum: Mapped[Optional[str]] = mapped_column("curriculum", String(2048))
    linkedin: Mapped[Optional[str]] = mapped_column(String(2048))
    github: Mapped[Optional[str]] = mapped_column(String(2048))
    updated_at: Mapped[datetime] = mapped_column(index=True)
    created_at: Mapped[datetime] = mapped_column(index=True)
    birthday: Mapped[Optional[datetime]] = mapped_column(Date)

    matriculation: Mapped[List[UserMatriculation]] = relationship(UserMatriculation)

    scopes: Mapped[List[str]] = mapped_column(
        MutableList.as_mutable(ARRAY(Text)), default=[]
    )

    for_event: Mapped[Optional[int]] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.event.id"), default=None
    )

    @hybrid_property
    def image(self) -> Optional[AnyHttpUrl]:
        return self._image and settings.STATIC_URL + self._image

    @image.setter
    def image(self, image: Optional[AnyHttpUrl]):
        self._image = image

    @hybrid_property
    def curriculum(self) -> Optional[AnyHttpUrl]:
        return self._curriculum and settings.STATIC_URL + self._curriculum

    @curriculum.setter
    def curriculum(self, curriculum: Optional[AnyHttpUrl]):
        self._curriculum = curriculum
