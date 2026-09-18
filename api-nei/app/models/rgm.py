import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.config import settings
from app.db.base_class import Base


class Rgm(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    category: Mapped[str] = mapped_column(String(3))
    mandate: Mapped[str] = mapped_column(String(7), index=True)
    date: Mapped[datetime]
    title: Mapped[str] = mapped_column(String(264))
    _file: Mapped[str] = mapped_column("file", String(2048))
    # Uploaded via nei-directus (separate repo — see AUTHENTICATION.md
    # "Directus SSO"); additive, nullable, added by api-nei's
    # e8a1c9f3d6b7 migration. Preferred over `_file` when set.
    file_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))

    @hybrid_property
    def file(self) -> str:
        if self.file_asset:
            return f"{settings.DIRECTUS_PUBLIC_URL}assets/{self.file_asset}"
        return settings.STATIC_URL + self._file

    @file.setter
    def file(self, file: str):
        self._file = file
