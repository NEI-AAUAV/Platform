from typing import List, Optional
from pydantic import BaseModel, Field
from app.models import BaseDocument


class Vote(BaseModel):
    uid: int
    option: int


class VoteCategory(BaseDocument):
    id: int = Field(alias="_id")
    category: str
    options: List[str]
    votes: List[Vote]


class VoteListing(BaseDocument):
    id: int = Field(alias="_id")
    category: str
    options: List[str]
    scores: List[int]
    already_voted: Optional[int]
