from sqlalchemy import Table, Column, SmallInteger, Integer, String, ForeignKey, Computed
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


group_teams = Table(
    "group_teams",
    Base.metadata,
    Column("group_id", Integer, ForeignKey(settings.SCHEMA_NAME + ".group.id"),
           primary_key=True),
    Column("team_id", Integer, ForeignKey(settings.SCHEMA_NAME + ".team.id"),
           primary_key=True),
    schema=settings.SCHEMA_NAME,
)


class Group(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    competition_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME +
                   ".competition.id", ondelete='CASCADE'),
        nullable=False,
        index=True
    )
    number = Column(SmallInteger)
    name = Column(String(20), Computed(
        "CASE WHEN number IS NULL THEN null ELSE 'Grupo ' || CHR(number) END"))

    matches = relationship(
        "Match",
        cascade="all",
        passive_deletes=True,
        lazy='joined',
    )
    teams = relationship(
        "Team",
        secondary=group_teams,
        cascade="all",
        # passive_deletes=True,
        # lazy='joined',
    )
