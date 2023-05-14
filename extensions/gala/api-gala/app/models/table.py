from enum import Enum
from typing import List, Optional
from pydantic import BaseModel, PositiveInt, Field
from app.models import BaseDocument


class DishType(str, Enum):
    NORMAL = "NOR"
    VEGETARIAN = "VEG"


class Companion(BaseModel):
    dish: DishType
    allergies: str = ""


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

    def confirmed_seats(self) -> int:
        return sum(
            1 + len(person.companions) for person in self.persons if person.confirmed
        )
