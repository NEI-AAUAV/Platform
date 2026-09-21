from typing import List, TYPE_CHECKING

from sqlalchemy import CheckConstraint, String
from sqlalchemy.orm import Mapped, declared_attr, mapped_column, relationship

from app.db.base_class import Base

if TYPE_CHECKING:
    from .rgm import Rgm


class RgmMandate(Base):
    """RGM's own mandate calendar — independent from team NEI and
    Comissão de Faina mandates (see
    alembic revision c1d5e9a3f7b2).
    """

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    label: Mapped[str] = mapped_column(String(7), unique=True)

    @declared_attr.directive
    def __table_args__(cls):
        return (
            CheckConstraint("label ~ '^[0-9]{4}(/[0-9]{2})?$'", name="label_format"),
            Base.__table_args__,
        )

    documents: Mapped[List["Rgm"]] = relationship(
        "Rgm",
        back_populates="mandate_ref",
        order_by="Rgm.date.desc()",
    )
