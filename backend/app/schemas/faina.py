from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated


class FainaBase(BaseModel):
    imagem: Annotated[str, Field(max_length=255)]
    anoLetivo: Annotated[str, Field(max_length=9)]


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""
    imagem: Annotated[str, Field(max_length=255)]
    anoLetivo: Annotated[str, Field(max_length=9)]


class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""
    imagem: Annotated[str, Field(max_length=255)]
    anoLetivo: Annotated[str, Field(max_length=9)]


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""
    mandato: int

    class Config:
        orm_mode = True
