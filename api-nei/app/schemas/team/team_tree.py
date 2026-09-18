from typing import List, Optional

from pydantic import BaseModel, AnyHttpUrl, ConfigDict


class TeamMemberNode(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: Optional[int] = None
    name: str
    role: str
    weight: int
    header: Optional[AnyHttpUrl] = None


class TeamSectionNode(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    weight: int
    members: List[TeamMemberNode]


class TeamCategoryNode(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    weight: int
    sections: List[TeamSectionNode]


class TeamMandateTree(BaseModel):
    mandate: str
    categories: List[TeamCategoryNode]
