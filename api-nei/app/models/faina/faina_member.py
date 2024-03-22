from typing import Optional

from sqlalchemy import ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship

from app.core.config import settings
from app.db.base_class import Base
from app.models.user import User
from .faina_role import FainaRole


class FainaMember(Base):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    member_id: Mapped[Optional[int]] = mapped_column(ForeignKey(User.id), index=True)
    faina_id: Mapped[int] = mapped_column(
        ForeignKey(f"{settings.SCHEMA_NAME}.faina.id"), index=True
    )
    role_id: Mapped[int] = mapped_column(ForeignKey(FainaRole.id), index=True)

    @declared_attr.directive
    def __table_args__(cls):
        return (
            UniqueConstraint("member_id", "faina_id", "role_id"),
            Base.__table_args__,
        )

    member: Mapped[Optional[User]] = relationship(User, foreign_keys=[member_id])
    role: Mapped[FainaRole] = relationship(FainaRole, foreign_keys=[role_id])
