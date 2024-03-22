from datetime import datetime
from sqlalchemy import ForeignKey, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from app.models.user import User
from app.db.base_class import Base


class DeviceLogin(Base):
    user_id: Mapped[int] = mapped_column(
        ForeignKey(User.id, ondelete="CASCADE"), primary_key=True
    )
    session_id: Mapped[int] = mapped_column(primary_key=True)
    refreshed_at: Mapped[datetime]
    expires_at: Mapped[datetime]
