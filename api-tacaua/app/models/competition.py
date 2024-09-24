from typing import Optional, Any
from sqlalchemy.ext.mutable import MutableDict
from sqlalchemy.orm import Mapped, mapped_column, relationship, validates
from sqlalchemy import SmallInteger, String, JSON, ForeignKey, Boolean

from app.core.config import settings
from app.schemas.competition import Metadata
from app.db.base_class import Base


class Competition(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    modality_id: Mapped[int] = mapped_column(
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete="CASCADE"),
        index=True,
    )
    number: Mapped[Optional[int]] = mapped_column(
        SmallInteger
    )  # Used to order competitions
    division: Mapped[Optional[int]] = mapped_column(SmallInteger)
    name: Mapped[str] = mapped_column(String(50))
    started: Mapped[Optional[bool]] = mapped_column(Boolean, default=False)
    public: Mapped[Optional[bool]] = mapped_column(Boolean, default=False)
    _metadata: Mapped[Optional[dict[str, Any]]] = mapped_column(
        "metadata", MutableDict.as_mutable(JSON)
    )

    groups = relationship(
        "Group",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )

    @validates("_metadata")
    def validate_metadata(self, key, value):
        Metadata.model_validate(value)
        return value
