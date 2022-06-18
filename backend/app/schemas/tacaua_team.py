from pydantic import BaseModel, Field, HttpUrl

from typing_extensions import Annotated


class TacaUATeamBase(BaseModel):
    name: Annotated[str, Field(max_length=50)]
    image_url: HttpUrl


class TacaUATeamInDB(TacaUATeamBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True


class TacaUATeam(TacaUATeamInDB):
    """Properties to return via API."""
    pass

