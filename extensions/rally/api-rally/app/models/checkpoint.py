from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class CheckPoint(Base):
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str]
    shot_name: Mapped[str]
    description: Mapped[str]
