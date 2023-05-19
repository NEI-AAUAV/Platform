from enum import Enum
from datetime import datetime, date
from typing import Optional, List

from pydantic import BaseModel, constr, AnyHttpUrl, root_validator, Field

from app.utils import include, validate_to_json

from .user_academic_details import UserAcademicDetailsInBD


class GenderEnum(str, Enum):
    MALE = 'M'
    FEMALE = 'F'


class ScopeEnum(str, Enum):
    """Permission scope of an authenticated user."""
    ADMIN = 'admin'
    MANAGER_NEI = 'manager-nei'
    MANAGER_TACAUA = 'manager-tacaua'
    MANAGER_FAMILY = 'manager-family'
    MANAGER_JANTAR_GALA = "manager-jantar-gala"
    DEFAULT = 'default'


class UserBase(BaseModel):
    name: constr(max_length=20)
    surname: constr(max_length=20)
    gender: Optional[GenderEnum]
    linkedin: Optional[AnyHttpUrl]  # Optional[constr(max_length=100)]
    github: Optional[AnyHttpUrl]  # Optional[constr(max_length=39)]
    # Allow to receive datetime but then convert to date
    birthday: Optional[datetime | date]


@include(["created_at", "updated_at"])
class UserCreate(UserBase):
    """Properties to add to the database on create."""

    hashed_password: Optional[str]
    scopes: List[ScopeEnum] = []
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)


@include(["updated_at"])
@validate_to_json
class UserUpdate(UserBase):
    """Properties to receive via API on create."""

    name: Optional[constr(max_length=20)]
    surname: Optional[constr(max_length=20)]
    updated_at: datetime = Field(default_factory=datetime.now)


class UserInDB(UserBase):
    """Properties properties stored in DB."""

    id: int
    iupi: Optional[constr(max_length=36)]
    nmec: Optional[int]
    image: Optional[AnyHttpUrl]
    curriculum: Optional[AnyHttpUrl]
    created_at: datetime
    updated_at: datetime
    birthday: Optional[date]
    scopes: List[ScopeEnum] = []
    academic_details: list[UserAcademicDetailsInBD] | list  
    # TODO: sometimes i need to put list, but it feels wrong, fix this

    class Config:
        orm_mode = True
