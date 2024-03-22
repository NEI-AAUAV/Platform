from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base


class Course(Base):
    code: Mapped[int] = mapped_column(primary_key=True, autoincrement=False)
    name: Mapped[str] = mapped_column(String(128))
    short: Mapped[Optional[str]] = mapped_column(String(8))
    public: Mapped[bool] = mapped_column(default=False)
