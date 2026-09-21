from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base


class NoteAuthor(Base):
    """Author of a note who has no Platform account (managed in the CMS)."""

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(50))
    surname: Mapped[str] = mapped_column(String(50))
