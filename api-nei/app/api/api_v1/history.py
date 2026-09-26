import asyncio
from typing import Any, List, Optional
from urllib.parse import urlparse

from fastapi import APIRouter, Depends, HTTPException
from fastapi.concurrency import run_in_threadpool
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
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

# The list waits at most this long for Drive before answering without
# folder counts; the folder keeps resolving into the cache for next time.
_LIST_DRIVE_BUDGET_SECONDS = 2.5


def _media_out(media: HistoryMedia) -> HistoryMediaOut | None:
    if media.photo_asset:
        return HistoryMediaOut(
            id=f"upload:{media.id}",
            url=media.url,
            thumb=f"{media.url}?width=600",
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


def _to_out(milestone: History) -> HistoryOut:
    media = _own_media(milestone)
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
        media=media,
        has_drive_gallery=bool(milestone.drive_folder_url),
        gallery_count=None if milestone.drive_folder_url else len(media),
        cover=milestone.image or (media[0].thumb if media else None),
    )


def _load_list(db: Session) -> list[tuple[HistoryOut, Optional[str]]]:
    return [
        (_to_out(m), extract_folder_id(m.drive_folder_url or ""))
        for m in crud.history.get_multi(db=db)
    ]


async def _resolve_folders(folder_ids: set[str]) -> dict[str, DriveFolderResult]:
    async def resolve(folder_id: str) -> DriveFolderResult:
        return await asyncio.wait_for(
            drive_client.list_folder(folder_id), _LIST_DRIVE_BUDGET_SECONDS
        )

    ordered = list(folder_ids)
    results = await asyncio.gather(
        *(resolve(f) for f in ordered), return_exceptions=True
    )
    return {
        folder_id: result
        for folder_id, result in zip(ordered, results)
        if isinstance(result, DriveFolderResult)
    }


def _with_folder(out: HistoryOut, result: Optional[DriveFolderResult]) -> HistoryOut:
    if result is None or result.status == "error":
        # Unknown: the page shows the gallery button and lets the gallery
        # endpoint try again.
        return out
    folder = _folder_media(result, out.media)
    return out.model_copy(
        update={
            "gallery_count": len(out.media) + len(folder),
            "cover": out.cover or (folder[0].thumb if folder else None),
        }
    )


@router.get("/", status_code=200, response_model=List[HistoryOut])
async def get(
    *, db: Session = Depends(deps.get_db, scope="function"),
    _ = Depends(deps.cms_cache)
) -> Any:
    rows = await run_in_threadpool(_load_list, db)
    folders = await _resolve_folders({f for _, f in rows if f})
    return [
        _with_folder(out, folders.get(folder_id)) if out.has_drive_gallery else out
        for out, folder_id in rows
    ]


def _load_gallery(db: Session, id: int) -> Optional[tuple[HistoryGalleryOut, Optional[str]]]:
    milestone = crud.history.get_published(db=db, id=id)
    if not milestone:
        return None
    gallery = HistoryGalleryOut(
        id=milestone.id, title=milestone.title, media=_own_media(milestone)
    )
    return gallery, milestone.drive_folder_url


@router.get("/{id}/gallery", status_code=200, response_model=HistoryGalleryOut)
async def get_gallery(
    *, id: int, db: Session = Depends(deps.get_db, scope="function"),
    _ = Depends(deps.cms_cache)
) -> Any:
    loaded = await run_in_threadpool(_load_gallery, db, id)
    if loaded is None:
        raise HTTPException(status_code=404, detail="Marco não encontrado")
    gallery, folder_url = loaded
    if not folder_url:
        return gallery

    folder_id = extract_folder_id(folder_url)
    if not folder_id:
        return gallery.model_copy(update={"drive_status": "unavailable"})

    result = await drive_client.list_folder(folder_id)
    return gallery.model_copy(
        update={
            "media": gallery.media + _folder_media(result, gallery.media),
            "drive_status": result.status,
        }
    )
