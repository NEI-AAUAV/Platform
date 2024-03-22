from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column

from app.db.base_class import Base
from app.models.user import User


class TeamColaborator(Base):
    user_id: Mapped[int] = mapped_column(ForeignKey(User.id), primary_key=True)
    mandate: Mapped[str] = mapped_column(String(7), primary_key=True)

    user: Mapped[User] = relationship(User)
