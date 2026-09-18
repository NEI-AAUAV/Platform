from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column

from app.db.base_class import Base
from app.models.user import User


class TeamColaborator(Base):
    # Surrogate key (see alembic/versions/b5c7d9e1f3a5_team_colaborator_pk.py):
    # Directus cannot manage a collection with a composite primary key, so
    # `id` is now the real PK. The old (user_id, mandate) pair is preserved
    # as a UNIQUE constraint below, unchanged in meaning.
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey(User.id))
    mandate: Mapped[str] = mapped_column(String(7))

    user: Mapped[User] = relationship(User)
