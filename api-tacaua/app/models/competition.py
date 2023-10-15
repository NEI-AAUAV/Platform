from sqlalchemy.ext.mutable import MutableDict
from sqlalchemy.orm import relationship, validates
from sqlalchemy import Column, SmallInteger, Integer, String, JSON, ForeignKey, Boolean

from app.core.config import settings
from app.schemas.competition import Metadata
from app.db.base_class import Base


class Competition(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    number = Column(SmallInteger)  # Used to order competitions
    division = Column(SmallInteger)
    name = Column(String(50), nullable=False)
    started = Column(Boolean, default=False)
    public = Column(Boolean, default=False)
    _metadata = Column("metadata", MutableDict.as_mutable(JSON))

    groups = relationship(
        "Group",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )

    @validates("_metadata")
    def validate_metadata(self, key, value):
        Metadata.validate(value)
        return value
