from typing import List

from pydantic import BaseModel, Field, constr
from pydantic.dataclasses import dataclass

from app.utils import to_camel_case


class RoleInDB(BaseModel):
    id: int = Field(alias='_id')
    initials: constr(max_length=16, strip_whitespace=True)
    name: constr(max_length=128, strip_whitespace=True)
    super_roles: constr(regex=r'(,\d+,)*')

    class Config:
        orm = True
        allow_population_by_field_name = True
        alias_generator = to_camel_case
