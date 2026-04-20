from datetime import datetime
from typing import Optional
from sqlalchemy import ForeignKey, ForeignKey, Text
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
    oidc_id_token: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
