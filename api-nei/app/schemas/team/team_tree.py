from typing import List, Optional

from pydantic import BaseModel, AnyHttpUrl, ConfigDict

class TeamMemberSocial(BaseModel):
    """Only the public social links of the optionally linked account."""

    model_config = ConfigDict(from_attributes=True)

    linkedin: Optional[AnyHttpUrl] = None
    github: Optional[AnyHttpUrl] = None


class TeamMemberNode(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    # `name` is the canonical display identity. `user` is optional
    # enrichment (social links) for members linked to a platform account.
    name: str
    role: str
    weight: int
    header: Optional[AnyHttpUrl] = None
    user: Optional[TeamMemberSocial] = None


class TeamSectionNode(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    weight: int
    members: List[TeamMemberNode]


class TeamMandateTree(BaseModel):
    mandate: str
    sections: List[TeamSectionNode]
