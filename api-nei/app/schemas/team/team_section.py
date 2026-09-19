from typing import Optional

from pydantic import BaseModel, ConfigDict

from app.schemas.types import MandateStr


class TeamSectionBase(BaseModel):
    mandate: MandateStr
    name: str
    weight: int = 0


class TeamSectionCreate(TeamSectionBase):
    pass


class TeamSectionUpdate(BaseModel):
    mandate: Optional[MandateStr] = None
    name: Optional[str] = None
    weight: Optional[int] = None


class TeamSectionInDB(TeamSectionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
