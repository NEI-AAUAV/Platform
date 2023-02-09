from typing import Optional

from pydantic import AnyHttpUrl
from sqlalchemy import Column, Integer, String, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.user import PermissionEnum, GenderEnum


class User(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    iupi = Column(String(36), unique=True)
    nmec = Column(Integer, unique=True)
    email = Column(String(256), nullable=False, unique=True)
    hashed_password = Column(String(60))
    name = Column(String(16))
    surname = Column(String(16))
    gender = Column(
        Enum(GenderEnum, name="gender_enum", inherit_schema=True))
    _image = Column("image", String(2048))
    _curriculum = Column("curriculum", String(2048))
    linkedin = Column(String(100))
    github = Column(String(39))

    permission = Column(
        Enum(PermissionEnum, name="permission_enum", inherit_schema=True))
    updated_at = Column(DateTime, index=True)
    created_at = Column(DateTime, index=True)

    academic_details = relationship("UserAcademicDetails")

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


class UserAcademicDetails(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(
        Integer, 
        ForeignKey(settings.SCHEMA_NAME + ".user.id"), 
        index=True)
    course = Column(
        Integer, 
        ForeignKey(settings.SCHEMA_NAME + ".course.id"), 
        nullable=False, 
        index=True)
    subjects = ...
    curricular_year = Column(Integer, nullable=False)
    updated_at = Column(DateTime, index=True)
