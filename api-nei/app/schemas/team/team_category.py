from typing import Optional

from pydantic import BaseModel, ConfigDict

from app.schemas.types import MandateStr


class TeamCategoryBase(BaseModel):
    mandate: MandateStr
    name: str
    weight: int = 0


class TeamCategoryCreate(TeamCategoryBase):
    pass


class TeamCategoryUpdate(BaseModel):
    mandate: Optional[MandateStr] = None
    name: Optional[str] = None
    weight: Optional[int] = None


class TeamCategoryInDB(TeamCategoryBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
