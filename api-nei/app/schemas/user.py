from enum import Enum
from datetime import datetime
from typing import Optional, List

from pydantic import BaseModel, constr, AnyHttpUrl, root_validator, Field

from .user_academic_details import UserAcademicDetailsInBD


class GenderEnum(str, Enum):
    MALE = 'Masculino'
    FEMALE = 'Feminino'


class ScopeEnum(str, Enum):
    """Permission scope of an authenticated user."""
    ADMIN = 'admin'
    MANAGER_NEI = 'manager-nei'
    MANAGER_TACAUA = 'manager-tacaua'
    MANAGER_FAMILY = 'manager-family'
    DEFAULT = 'default'


class UserBase(BaseModel):
    name: constr(max_length=20)
    surname: constr(max_length=20)
    gender: Optional[GenderEnum]
    linkedin: Optional[constr(max_length=100)]
    github: Optional[constr(max_length=39)]


class UserCreate(UserBase):
    """Properties to receive via API on create."""
    email: str
    password: constr(min_length=8)
    password2: str
    # TODO: do not forget, already tried this:
    # https://github.com/tiangolo/fastapi/issues/1378
    # created_at: datetime = Field(default_factory=datetime.now)

    @root_validator
    def passwords_match(cls, values):
        if values.get('password') != values.get('password2'):
            raise ValueError('Passwords do not match')
        return values


class UserUpdate(UserBase):
    """Properties to receive via API on create."""
    name: Optional[constr(max_length=20)]
    surname: Optional[constr(max_length=20)]
    # TODO: do not forget
    # updated_at: datetime = Field(default_factory=datetime.now)


class UserInDB(UserBase):
    """Properties properties stored in DB."""
    id: int
    email: str
    iupi: Optional[constr(max_length=36)]
    nmec: Optional[int]
    image: Optional[AnyHttpUrl]
    curriculum: Optional[AnyHttpUrl]
    scopes: List[ScopeEnum] = []
    academic_details: List[UserAcademicDetailsInBD]

    class Config:
        orm_mode = True
