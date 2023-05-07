from typing import List, Optional
from pydantic import BaseModel, PositiveInt, Field
from app.models import BaseDocument


class TablePerson(BaseModel):
    id: int
    companions: int
    confirmed: bool


class Table(BaseDocument):
    id: int = Field(alias="_id")
    name: Optional[str]
    head: Optional[int]
    seats: PositiveInt
    persons: List[TablePerson]
