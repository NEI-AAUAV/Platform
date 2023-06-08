from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, DateTime, Enum, Text, Date
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.user import ScopeEnum, GenderEnum


class User(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    iupi = Column(String(36), unique=True)
    nmec = Column(Integer, unique=True)
    hashed_password = Column(Text)
    name = Column(String(20), nullable=False)
    surname = Column(String(20), nullable=False)
    gender = Column(Enum(GenderEnum, name="gender_enum", inherit_schema=True))
    _image = Column("image", String(2048))
    _curriculum = Column("curriculum", String(2048))
    linkedin = Column(String(2048)) # Column(String(100))
    github = Column(String(2048)) # Column(String(39))
    scopes = Column(ARRAY(Enum(ScopeEnum, name="scope_enum", inherit_schema=True)))
    updated_at = Column(DateTime, nullable=False, index=True)
    created_at = Column(DateTime, nullable=False, index=True)
    birthday = Column(Date)

    matriculation = relationship("UserMatriculation")

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
