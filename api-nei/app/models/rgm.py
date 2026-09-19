import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import CheckConstraint, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship
from sqlalchemy.ext.hybrid import hybrid_property

from app.core.assets import asset_url
from app.core.config import settings
from app.db.base_class import Base
from .rgm_mandate import RgmMandate


class Rgm(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    category: Mapped[str] = mapped_column(String(3))
    # Legacy text; `mandate_id` -> rgm_mandate is authoritative (see `mandate`).
    _mandate: Mapped[Optional[str]] = mapped_column("mandate", String(7), index=True)
    date: Mapped[datetime]
    title: Mapped[str] = mapped_column(String(264))
    _file: Mapped[Optional[str]] = mapped_column("file", String(2048))
    # Uploaded via nei-directus (separate repo — see AUTHENTICATION.md
    # "Directus SSO"); additive, nullable, added by api-nei's
    # e8a1c9f3d6b7 migration. Preferred over `_file` when set.
    file_asset: Mapped[Optional[uuid.UUID]] = mapped_column(UUID(as_uuid=True))
    # `mandate` (above) is the legacy free-text column, kept for compat.
    # mandate_id is the real FK to RGM's own mandate calendar, additive.
    mandate_id: Mapped[int] = mapped_column(
        ForeignKey(RgmMandate.id, ondelete="RESTRICT"), nullable=False, index=True
    )

    # Directus bypasses the API's validation, so the invariant lives here.
    @declared_attr.directive
    def __table_args__(cls):
        return (
            CheckConstraint("category IN ('ATA', 'PAO', 'RAC')", name="category_valid"),
            Base.__table_args__,
        )

    mandate_ref: Mapped[RgmMandate] = relationship(
        RgmMandate, foreign_keys=[mandate_id], back_populates="documents"
    )

    @property
    def mandate(self) -> Optional[str]:
        if self.mandate_ref is not None:
            return self.mandate_ref.label
        return self._mandate

    @mandate.setter
    def mandate(self, mandate: Optional[str]):
        self._mandate = mandate

    @hybrid_property
    def file(self) -> Optional[str]:
        if self.file_asset:
            return asset_url(self.file_asset)
        return self._file and settings.STATIC_URL + self._file

    @file.setter
    def file(self, file: str):
        self._file = file
