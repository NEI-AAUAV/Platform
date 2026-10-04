from datetime import datetime
from typing import Any, Optional

from sqlalchemy import DateTime, String
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base


class AdminActivity(Base):
    """Append-only audit trail. Names are copied in, not joined, so an entry
    still says who did what after either account is deleted."""

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    actor_id: Mapped[Optional[int]]
    actor_name: Mapped[Optional[str]] = mapped_column(String(41))
    action: Mapped[str] = mapped_column(String(50))
    target_user_id: Mapped[Optional[int]]
    target_name: Mapped[Optional[str]] = mapped_column(String(41))
    detail: Mapped[Optional[dict[str, Any]]] = mapped_column(JSONB)
