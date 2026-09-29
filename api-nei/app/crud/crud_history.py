from typing import NamedTuple, Optional, Sequence

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session, joinedload, selectinload

from app.crud.base import CRUDBase
from app.integrations.google_drive import DRIVE_FILE_URL_PATTERN
from app.models.history import History, HistoryMedia
from app.schemas.history import HistoryCreate, HistoryUpdate


class GallerySummary(NamedTuple):
    """What the timeline needs from a milestone's own photos: the first one
    (cover fallback) and how many there are, without loading the rest."""

    first: HistoryMedia
    total: int


# Rows the API can turn into a photo; a Drive link it cannot parse is
# dropped by the gallery, so it must not be counted by the timeline either.
_USABLE_MEDIA = or_(
    HistoryMedia.photo_asset.is_not(None),
    HistoryMedia.drive_url.regexp_match(DRIVE_FILE_URL_PATTERN),
)


class CRUDHistory(CRUDBase[History, HistoryCreate, HistoryUpdate]):
    def get_multi(self, db: Session, **_: object) -> Sequence[History]:
        """Published milestones, newest first. `media` is not loaded: use
        `gallery_summaries` for what the timeline shows of it."""
        statement = (
            select(History)
            .where(History.published.is_(True))
            .options(joinedload(History.category))
            .order_by(History.moment.desc(), History.id.desc())
        )
        return db.scalars(statement).all()

    def gallery_summaries(self, db: Session) -> dict[int, GallerySummary]:
        """One query, one row per published milestone with usable photos,
        however many photos each has."""
        ranked = (
            select(
                HistoryMedia.id,
                func.count()
                .over(partition_by=HistoryMedia.history_id)
                .label("usable"),
                func.row_number()
                .over(
                    partition_by=HistoryMedia.history_id,
                    order_by=(HistoryMedia.weight, HistoryMedia.id),
                )
                .label("position"),
            )
            .join(History, History.id == HistoryMedia.history_id)
            .where(History.published.is_(True), _USABLE_MEDIA)
            .subquery()
        )
        statement = (
            select(HistoryMedia, ranked.c.usable)
            .join(ranked, ranked.c.id == HistoryMedia.id)
            .where(ranked.c.position == 1)
        )
        return {
            media.history_id: GallerySummary(media, usable)
            for media, usable in db.execute(statement).all()
        }

    def get_published(self, db: Session, id: int) -> Optional[History]:
        statement = (
            select(History)
            .where(History.id == id, History.published.is_(True))
            .options(selectinload(History.media), joinedload(History.category))
        )
        return db.scalars(statement).first()


history = CRUDHistory(History)
