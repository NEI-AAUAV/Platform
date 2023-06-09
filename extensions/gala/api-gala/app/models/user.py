from typing import Annotated, Optional
from pydantic import BaseModel, Field
from app.models import BaseDocument


class Matriculation(BaseModel):
    __root__: Annotated[int, Field(ge=1, le=5)]


class User(BaseDocument):
    id: int = Field(alias="_id")
    matriculation: Optional[Matriculation]
    nmec: int
    email: Optional[str]
    name: str
    has_payed: bool = False
