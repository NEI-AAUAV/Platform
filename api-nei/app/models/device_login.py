from datetime import datetime
from typing import Optional
from sqlalchemy import DateTime, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.models.user import User
from app.db.base_class import Base


class DeviceLogin(Base):
    user_id: Mapped[int] = mapped_column(
        ForeignKey(User.id, ondelete="CASCADE"), primary_key=True
    )
    session_id: Mapped[int] = mapped_column(primary_key=True)
    refreshed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    oidc_id_token: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    refresh_jti: Mapped[Optional[str]] = mapped_column(String(64), nullable=True)
