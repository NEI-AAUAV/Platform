from pydantic import BaseModel, ConfigDict


class TeamSectionBase(BaseModel):
    mandate_id: int
    name: str
    weight: int = 0


class TeamSectionInDB(TeamSectionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
