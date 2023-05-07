from enum import Enum
from typing import Annotated, Optional
from pydantic import BaseModel, Field
from app.models import BaseDocument


class Matriculation(BaseModel):
    __root__: Annotated[int, Field(ge=1, le=5)]


class DishType(str, Enum):
    NORMAL = "NOR"
    VEGETARIAN = "VEG"


class User(BaseDocument):
    id: int = Field(alias="_id")
    matriculation: Optional[Matriculation]
    nmec: Optional[int]
    email: str
    name: str
    dish: DishType
    has_payed: bool = False
    allergies: str
