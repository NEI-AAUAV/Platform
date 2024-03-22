from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, Annotated

from app.utils import optional


class FainaRoleBase(BaseModel):
    name: Annotated[str, Field(max_length=20)]
    weight: Optional[int] = None


class FainaRoleCreate(FainaRoleBase):
    """Properties to receive via API on creation."""

    ...


@optional()
class FainaRoleUpdate(FainaRoleBase):
    """Properties to receive via API on creation."""

    ...


class FainaRoleInDB(FainaRoleBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
