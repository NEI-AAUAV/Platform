from typing import List, Optional
from sqlalchemy import (
    Table,
    Column,
    SmallInteger,
    Integer,
    String,
    ForeignKey,
    Computed,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.config import settings
from app.db.base_class import Base

# Needs to be done this way because of circular dependencies
import app.models.match
import app.models.team


group_teams = Table(
    "group_teams",
    Base.metadata,
    Column(
        "group_id",
        Integer,
        ForeignKey(f"{settings.SCHEMA_NAME}.group.id"),
        primary_key=True,
    ),
    Column(
        "team_id",
        Integer,
        ForeignKey(f"{settings.SCHEMA_NAME}.team.id"),
        primary_key=True,
    ),
    schema=settings.SCHEMA_NAME,
)


class Group(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    competition_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.competition.id", ondelete="CASCADE"),
        index=True,
    )
    number: Mapped[Optional[int]] = mapped_column(SmallInteger)  # Used to order groups
    name: Mapped[Optional[str]] = mapped_column(
        String(20),
        Computed("CASE WHEN number IS NULL THEN null ELSE 'Grupo ' || CHR(number) END"),
    )  # Computes 'Grupo A' for number '1'

    matches: Mapped[List["app.models.match.Match"]] = relationship(
        "app.models.match.Match",
        cascade="all",
        passive_deletes=True,
        lazy="joined",
    )
    teams: Mapped[List["app.models.team.Team"]] = relationship(
        "app.models.team.Team",
        secondary=group_teams,
        cascade="all",
        # passive_deletes=True,
        # lazy='joined',
    )
