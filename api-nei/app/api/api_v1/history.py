from typing import Any, List, Optional
from urllib.parse import urlparse

from fastapi import APIRouter, Depends, HTTPException, Response
from fastapi.concurrency import run_in_threadpool
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.crud.crud_history import GallerySummary
from app.integrations.google_drive import (
    DriveFolderResult,
    drive_client,
    drive_image_url,
    extract_file_id,
    extract_folder_id,
)
from app.models.history import History, HistoryMedia
from app.schemas.history import (
    HistoryCategoryOut,
    HistoryGalleryOut,
    HistoryMediaOut,
    HistoryOut,
)

router = APIRouter()


def _media_out(media: HistoryMedia) -> HistoryMediaOut | None:
    if media.photo_asset:
        url = media.url
        if not url:
            return None
        return HistoryMediaOut(
            id=f"upload:{media.id}",
            url=url,
            thumb=f"{url}?width=600",
            caption=media.caption,
            source="upload",
        )
    if media.drive_url:
        file_id = extract_file_id(media.drive_url)
        if not file_id:
            return None
        return HistoryMediaOut(
            id=f"drive:{file_id}",
            url=drive_image_url(file_id, 2000),
            thumb=drive_image_url(file_id, 600),
            caption=media.caption,
            source="drive",
        )
    return None


def _own_media(milestone: History) -> list[HistoryMediaOut]:
    return [m for m in (_media_out(item) for item in milestone.media) if m]


def _folder_media(
    result: DriveFolderResult, own: list[HistoryMediaOut]
) -> list[HistoryMediaOut]:
    """Folder photos not already linked one-by-one in `own`."""
    seen = {m.id for m in own}
    return [
        HistoryMediaOut(
            id=f"drive:{image.file_id}",
            url=image.url,
            thumb=image.thumb_url,
            caption=image.caption,
            source="drive",
            width=image.width,
            height=image.height,
        )
        for image in result.images
        if f"drive:{image.file_id}" not in seen
    ]


def _safe_external_url(url: Optional[str]) -> Optional[str]:
    """Only http(s) links reach the page: anything else (`javascript:`,
    `data:`...) would be rendered as a clickable href."""
    if not url:
        return None
    return url if urlparse(url).scheme in ("http", "https") else None


def _cover(
    milestone: History, first: Optional[HistoryMediaOut]
) -> tuple[Optional[str], Optional[str]]:
    """The cover and its alt text. Only the milestone's own rows count: the
    list never waits on Drive, so a folder-only gallery has no cover unless
    editors set `image`."""
    if milestone.image:
        return milestone.image, milestone.image_alt
    if first:
        return first.thumb, first.caption
    return None, None


def _to_out(milestone: History, summary: Optional[GallerySummary]) -> HistoryOut:
    first = _media_out(summary.first) if summary else None
    cover, cover_alt = _cover(milestone, first)
    own_count = summary.total if summary else 0
    return HistoryOut(
        id=milestone.id,
        moment=milestone.moment,
        title=milestone.title,
        body=milestone.body,
        image=milestone.image,
        category=HistoryCategoryOut.model_validate(milestone.category)
        if milestone.category
        else None,
        featured=milestone.featured,
        mandate=milestone.mandate,
        external_url=_safe_external_url(milestone.external_url),
        external_label=milestone.external_label,
        has_drive_gallery=bool(milestone.drive_folder_url),
        gallery_count=None if milestone.drive_folder_url else own_count,
        cover=cover,
        cover_alt=cover_alt,
    )


def _load_list(db: Session) -> list[HistoryOut]:
    # Two queries whatever the gallery sizes: milestones, then one summary
    # row per milestone. Full photo lists are only loaded by /{id}/gallery.
    summaries = crud.history.gallery_summaries(db=db)
    return [_to_out(m, summaries.get(m.id)) for m in crud.history.get_multi(db=db)]


@router.get(
    "/",
    status_code=200,
    response_model=List[HistoryOut],
    dependencies=[Depends(deps.cms_cache)],
)
async def get(*, db: deps.DbSession) -> Any:
    # Database only: Drive-folder photos are resolved by /{id}/gallery, so the
    # timeline never waits on (or breaks with) Google Drive.
    return await run_in_threadpool(_load_list, db)


def _load_gallery(db: Session, id: int) -> Optional[tuple[HistoryGalleryOut, Optional[str]]]:
    milestone = crud.history.get_published(db=db, id=id)
    if not milestone:
        return None
    gallery = HistoryGalleryOut(
        id=milestone.id, title=milestone.title, media=_own_media(milestone)
    )
    return gallery, milestone.drive_folder_url


def _with_folder(gallery: HistoryGalleryOut, result: DriveFolderResult) -> HistoryGalleryOut:
    return gallery.model_copy(
        update={
            "media": gallery.media + _folder_media(result, gallery.media),
            "drive_status": result.status,
            "truncated": result.truncated,
        }
    )


@router.get(
    "/{id}/gallery",
    status_code=200,
    response_model=HistoryGalleryOut,
    responses={404: {"description": "Milestone not found or not published"}},
    dependencies=[Depends(deps.cms_cache)],
)
async def get_gallery(*, id: int, response: Response, db: deps.DbSession) -> Any:
    loaded = await run_in_threadpool(_load_gallery, db, id)
    if loaded is None:
        raise HTTPException(status_code=404, detail="Marco não encontrado")
    gallery, folder_url = loaded
    if not folder_url:
        return gallery

    folder_id = extract_folder_id(folder_url)
    if not folder_id:
        return gallery.model_copy(update={"drive_status": "unavailable"})

    # Bounded by the client's fetch budget, below web-nei's request timeout.
    result = await drive_client.list_folder(folder_id)
    if result.status == "error" or result.truncated:
        # Don't let the browser keep a degraded gallery for cms_cache's minute.
        response.headers["Cache-Control"] = "no-store"
    return _with_folder(gallery, result)
