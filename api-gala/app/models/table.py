from enum import Enum
from typing import List, Optional
from pydantic import BaseModel, PositiveInt, Field
from app.models import BaseDocument


class DishType(str, Enum):
    NORMAL = "NOR"
    VEGETARIAN = "VEG"


class Companion(BaseModel):
    allergies: str
    dish: DishType


class TablePerson(BaseModel):
    id: int
    allergies: str
    dish: DishType
    confirmed: bool
    companions: List[Companion]


class Table(BaseDocument):
    id: int = Field(alias="_id")
    name: Optional[str]
    head: Optional[int]
    seats: PositiveInt
    persons: List[TablePerson]
