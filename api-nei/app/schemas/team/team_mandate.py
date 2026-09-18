from typing import List

from pydantic import BaseModel

from app.schemas.types import MandateStr


class TeamMandateBase(BaseModel):
    mandate: MandateStr


class TeamMandateCreate(TeamMandateBase):
    pass


class TeamMandateInDB(TeamMandateBase):
    model_config = {"from_attributes": True}


class TeamMandates(BaseModel):
    data: List[str]
