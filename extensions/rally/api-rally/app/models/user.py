from typing import Optional
from sqlalchemy import ForeignKey
from sqlalchemy.orm import mapped_column, Mapped

from app.models.base import Base
from app.core.config import settings


class User(Base):
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str]
    team_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.team.id")
    )
    staff_checkpoint_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.check_point.id")
    )
    disabled: Mapped[bool] = mapped_column(default=False)
