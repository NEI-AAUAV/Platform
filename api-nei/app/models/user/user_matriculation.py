from datetime import datetime
from typing import List

from sqlalchemy import ARRAY, Integer, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.core.config import settings
from app.db.base_class import Base


class UserMatriculation(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.user.id"),
        index=True,
    )
    course_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.course.code"),
        index=True,
    )
    subject_ids: Mapped[List[int]] = mapped_column(ARRAY(Integer))
    curricular_year: Mapped[int]
    created_at: Mapped[datetime] = mapped_column(index=True)
