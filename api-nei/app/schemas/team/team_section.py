from typing import Optional

from pydantic import BaseModel, ConfigDict


class TeamSectionBase(BaseModel):
    mandate_id: int
    name: str
    weight: int = 0


class TeamSectionCreate(TeamSectionBase):
    pass


class TeamSectionUpdate(BaseModel):
    mandate_id: Optional[int] = None
    name: Optional[str] = None
    weight: Optional[int] = None


class TeamSectionInDB(TeamSectionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
