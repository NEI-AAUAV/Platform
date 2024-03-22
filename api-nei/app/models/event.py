from datetime import datetime
from sqlalchemy.orm import Mapped, relationship, mapped_column

from app.models.user import User
from app.db.base_class import Base


class Event(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str]

    start: Mapped[datetime]
    end: Mapped[datetime]

    users: Mapped[User] = relationship(User)
