from sqlalchemy import ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.models.user import User
from app.db.base_class import Base


class UserEmail(Base):
    user_id: Mapped[int] = mapped_column(
        ForeignKey(User.id, ondelete="CASCADE"), primary_key=True
    )
    email: Mapped[str] = mapped_column(Text, primary_key=True)
    active: Mapped[bool] = mapped_column(default=False)
