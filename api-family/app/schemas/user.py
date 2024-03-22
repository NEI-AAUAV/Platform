from typing import Generic, TypeVar, Optional, Literal, List

from pydantic import BaseModel, root_validator, validator, constr, conlist

from app.utils import to_camel_case


RefType = TypeVar("RefType", bound=str)


class RefYear(Generic[RefType], BaseModel):
    ref_id: RefType
    year: int                   # Matriculation year
    end_year: Optional[int]     # Last matriculation year (inclusive)

    @validator('end_year')
    def matriculation_years(cls, v: int, values):
        if v and v < values.get('year'):
            raise ValueError('end_year must be greater than year')
        return v

    class Config:
        # FIXME: dataclass?
        alias_generator = to_camel_case


class NameUntil(Generic[RefType], BaseModel):
    name: RefType
    until: Optional[int]        # Last matriculation year (inclusive)

    class Config:
        # FIXME: dataclass?
        alias_generator = to_camel_case


class FainaBase(BaseModel):
    # Trajado single name or names by year
    name: conlist(NameUntil, min_items=1)
    baptism_name: Optional[str]
    # NOTE: useful for predicting hierarchy
    first_trajado_year: Optional[int]
    # NOTE: expects Faina role references start by .1.
    roles: List[RefYear[constr(regex=r'^\.1\.')]] = []

    @root_validator
    def has_patrao_or_is_trajado(cls, values):
        if values.get('patrao_id') or values.get('first_trajado_year'):
            return values
        raise ValueError('Must have a patrão or be trajado')

    @validator('name', 'roles')
    def sort_ref_years(cls, v):
        return sorted(v, key=lambda m: m.get('year'))

    @validator('name')
    def has_always_one_name(cls, v):
        for i in range(len(v) - 1):
            if not v[i].until:
                raise ValueError('Can not have two names in one year')
        return v


class FainaCreate(FainaBase):
    baptism_year: int
    patrao_id: Optional[int]


class FainaUpdate(FainaBase):
    # NOTE: forbids patrao changes without approval
    # FIXME: roles can only be added to already aproved roles, not modified
    name: Optional[conlist(RefYear, min_items=1)]


class FainaAdminUpdate(FainaUpdate):
    baptism_year: int
    patrao_id: Optional[int]


class FainaInDB(FainaBase):
    baptism_year: int       # NOTE: useful for ordering users
    patrao_id: Optional[int]

    class Config:
        # FIXME: do i need this? dataclass?
        orm = True
        allow_population_by_field_name = True
        alias_generator = to_camel_case


class AcademicBase(BaseModel):
    matriculations: List[RefYear[int]]
    roles: List[RefYear] = []
    # NOTE: useful for ordering users
    last_matriculation_year: Optional[int]

    @validator('matriculations', 'roles')
    def sort_ref_years(cls, v):
        return sorted(v, key=lambda m: m.get('year'))

    @validator('last_matriculation_year', always=True)
    def get_last_matriculation_year(cls, v, values):
        # FIXME: careful, this disappears with exclude_unset=True
        m = values.get('matriculations')
        if m and len(m) > 1:
            return m[-1].end_year
        return None


AcademicCreate = AcademicBase

AcademicUpdate = AcademicBase


class AcademicInDB(AcademicBase):
    class Config:
        # FIXME: do i need this? dataclass?
        orm = True
        allow_population_by_field_name = True
        alias_generator = to_camel_case


class UserBase(BaseModel):
    ref_id: Optional[int]      # Reference to a NEI Service user ID
    name: constr(max_length=40)
    sex: Literal['M', 'F']


class UserCreate(UserBase):
    faina: Optional[FainaCreate]
    academic: Optional[AcademicCreate]

    @root_validator
    def not_both_none(cls, values):
        if values.get('faina') or values.get('academic'):
            return values
        raise ValueError('Must have faina or academic details')


class UserUpdate(UserBase):
    faina: Optional[FainaUpdate]
    academic: Optional[AcademicUpdate]


class UserAdminUpdate(UserUpdate):
    faina: Optional[FainaAdminUpdate]
    academic: Optional[AcademicUpdate]


class UserInDB(UserBase):
    id: int
    image: Optional[str]
    faina: Optional[FainaInDB]
    academic: Optional[AcademicInDB]

    class Config:
        extra = 'forbid'
        orm_mode = True
        # TODO: check necessity of these features:
        # extra = 'allow'
        # use_enum_values = True,
        # json_loads, json_dumps, json_enconders
