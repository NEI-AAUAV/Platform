from pydantic import BaseModel, ConfigDict


class CheckPointBase(BaseModel):
    name: str
    shot_name: str
    description: str


class CheckPointCreate(CheckPointBase):
    id: int


class CheckPointUpdate(BaseModel):
    pass


class CheckPointInDB(CheckPointBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
