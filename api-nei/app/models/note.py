import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import ForeignKey, SmallInteger, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User
from app.models.subject import Subject
from app.models.teacher import Teacher


class Note(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    author_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(User.id, name="fk_author_id"), index=True
    )
    subject_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(Subject.code, name="fk_subject_id"),
        index=True,
    )
    teacher_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey(Teacher.id, name="fk_teacher_id"),
        index=True,
    )

    name: Mapped[str] = mapped_column(String(256))
    _location: Mapped[Optional[str]] = mapped_column("location", String(2048))
    # Uploaded via nei-directus; additive, nullable — preferred over
    # `_location` when set (see rgm.py's file_asset for the same pattern).
    location_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    year: Mapped[Optional[int]] = mapped_column(SmallInteger, index=True)

    summary: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    tests: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    bibliography: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    slides: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    exercises: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    projects: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")
    notebook: Mapped[int] = mapped_column(SmallInteger, default=0, server_default="0")

    created_at: Mapped[datetime] = mapped_column(index=True)

    author: Mapped[Optional[User]] = relationship(User, foreign_keys=[author_id])
    subject: Mapped[Optional[Subject]] = relationship(
        Subject, foreign_keys=[subject_id]
    )
    teacher: Mapped[Optional[Teacher]] = relationship(
        Teacher, foreign_keys=[teacher_id]
    )

    @hybrid_property
    def location(self) -> str:
        if self.location_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.location_asset}"
        if not self._location:
            return ""
        if self._location.startswith("/"):
            return settings.STATIC_URL + self._location
        return self._location

    @location.setter
    def location(self, location: str):
        self._location = location
