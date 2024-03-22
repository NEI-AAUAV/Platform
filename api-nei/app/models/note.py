from datetime import datetime
from typing import Optional

from sqlalchemy import ForeignKey, SmallInteger, String
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
    _location: Mapped[str] = mapped_column("location", String(2048))
    year: Mapped[Optional[int]] = mapped_column(SmallInteger, index=True)

    summary: Mapped[int] = mapped_column(SmallInteger)
    tests: Mapped[int] = mapped_column(SmallInteger)
    bibliography: Mapped[int] = mapped_column(SmallInteger)
    slides: Mapped[int] = mapped_column(SmallInteger)
    exercises: Mapped[int] = mapped_column(SmallInteger)
    projects: Mapped[int] = mapped_column(SmallInteger)
    notebook: Mapped[int] = mapped_column(SmallInteger)

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
        if str(self._location).startswith("/"):
            return settings.STATIC_URL + self._location
        return self._location

    @location.setter
    def location(self, location: str):
        self._location = location
