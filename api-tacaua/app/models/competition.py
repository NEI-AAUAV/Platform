from sqlalchemy import Column, SmallInteger, Integer, String, JSON, ForeignKey, Boolean
from sqlalchemy.orm import relationship, validates
from sqlalchemy.dialects.postgresql import ARRAY

from app.core.config import settings
from app.schemas.competition import Metadata
from app.db.base_class import Base


class Competition(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    modality_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".modality.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    division = Column(SmallInteger)
    name = Column(String(50), nullable=False)
    started = Column(Boolean, default=False)
    public = Column(Boolean, default=False)
    metadata_ = Column('metadata', JSON)

    groups = relationship(
        "Group",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )

    @validates("metadata_")
    def validate_metadata(self, key, value):
        Metadata.validate(value)
        return value
