from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base_class import Base


class FainaRole(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(20))
    # Safe default so creating a role from Directus never needs a manually
    # supplied ordering number (see alembic migration c6d8e0f2a4b6).
    weight: Mapped[int] = mapped_column(default=0, server_default="0")
