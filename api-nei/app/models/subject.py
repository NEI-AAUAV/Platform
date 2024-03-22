from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base


class Subject(Base):
    code: Mapped[int] = mapped_column(primary_key=True, autoincrement=False)
    curricular_year: Mapped[Optional[int]]
    name: Mapped[str] = mapped_column(String(128))
    short: Mapped[str] = mapped_column(String(8))
    link: Mapped[Optional[str]] = mapped_column(String(2048))
    public: Mapped[bool] = mapped_column(default=False)
