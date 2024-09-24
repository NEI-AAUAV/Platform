from typing import Optional, Annotated

from pydantic import AnyHttpUrl, BaseModel, ConfigDict, StringConstraints


class ParticipantBase(BaseModel):
    name: Annotated[str, StringConstraints(max_length=50)]


class ParticipantCreate(ParticipantBase):
    team_id: int
    pass


class ParticipantUpdate(ParticipantBase):
    name: Optional[Annotated[str, StringConstraints(max_length=50)]] = None


class Participant(ParticipantBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    team_id: int
    image: Optional[AnyHttpUrl]
