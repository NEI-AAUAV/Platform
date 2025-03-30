from typing import List
from datetime import datetime
from sqlalchemy import DateTime, Integer, Boolean
from sqlalchemy.orm import Mapped, relationship, mapped_column
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.ext.mutable import MutableList

from app.models.base import Base
from app.models.user import User


class Team(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(unique=True)

    times: Mapped[List[datetime]] = mapped_column(
        MutableList.as_mutable(ARRAY(DateTime(timezone=False))), default=[]
    )

    score_per_checkpoint: Mapped[List[int]] = mapped_column(ARRAY(Integer), default=[])

    total: Mapped[int] = mapped_column(default=0)
    classification: Mapped[int] = mapped_column(default=-1)

    members: Mapped[List[User]] = relationship()
