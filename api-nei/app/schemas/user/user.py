from enum import Enum
from datetime import datetime, date
from typing import Optional, List, Annotated

from pydantic import (
    BaseModel,
    SecretStr,
    StringConstraints,
    AnyHttpUrl,
    Field,
    field_serializer,
    field_validator,
    ConfigDict,
)
from email_validator import validate_email, EmailNotValidError

from app.utils import ValidateFromJson
from app.api.deps import email_resolver
from app.core.config import settings

from .user_matriculation import UserMatriculationInBD


class GenderEnum(str, Enum):
    MALE = "M"
    FEMALE = "F"


class ScopeEnum(str, Enum):
    """Permission scope of an authenticated user."""

    ADMIN = "admin"
    MANAGER_NEI = "manager-nei"
    MANAGER_TACAUA = "manager-tacaua"
    MANAGER_FAMILY = "manager-family"
    MANAGER_JANTAR_GALA = "manager-jantar-gala"
    MANAGER_ARRAIAL = "manager-arraial"
    DEFAULT = "default"


class AnonymousUserBase(BaseModel):
    name: Optional[Annotated[str, StringConstraints(max_length=20)]] = None
    surname: Optional[Annotated[str, StringConstraints(max_length=20)]] = None
    gender: Optional[GenderEnum] = None
    linkedin: Optional[AnyHttpUrl] = None  # Optional[constr(max_length=100)]
    github: Optional[AnyHttpUrl] = None  # Optional[constr(max_length=39)]

    @field_serializer("linkedin", "github")
    def serialize_url(value: Optional[AnyHttpUrl]):
        if value is None:
            return None
        else:
            return str(value)


class UserBase(AnonymousUserBase):
    # Allow to receive datetime but then convert to date
    birthday: Optional[date] = None


class AnonymousUserListing(AnonymousUserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    curriculum: Optional[AnyHttpUrl] = None
    image: Optional[AnyHttpUrl] = None


class UserListing(AnonymousUserListing, UserBase):
    pass


class ManagerUserListing(UserListing):
    nmec: Optional[int] = None
    created_at: datetime
    updated_at: datetime
    matriculation: List[UserMatriculationInBD] = []
    email: Optional[str] = None


class AdminUserListing(ManagerUserListing):
    iupi: Optional[Annotated[str, StringConstraints(max_length=36)]]
    scopes: List[str] = []
    email: Optional[str] = None


class UserCreateBase(UserBase):
    name: Annotated[str, StringConstraints(max_length=20)]
    email: Annotated[str, Field(json_schema_extra={"format": "email"})]

    @field_validator("email")
    def email_is_valid(cls, v: str):
        try:
            validation = validate_email(
                v,
                check_deliverability=settings.PRODUCTION,
                dns_resolver=email_resolver,
            )
        except EmailNotValidError:
            raise ValueError("Email is invalid")
        return validation.normalized


class UserCreate(UserCreateBase):
    """Properties to add to the database on create."""

    password: Optional[SecretStr] = None
    scopes: List[ScopeEnum] = []


class UserCreateForEvent(UserCreateBase):
    """
    Schema used when importing users for an event.
    """

    pass


class UserUpdate(UserBase, ValidateFromJson):
    """Properties to receive via API on update."""

    nmec: Optional[int] = None
    iupi: Optional[Annotated[str, StringConstraints(max_length=36)]] = None
    scopes: List[str] = []
