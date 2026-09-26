from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.integrations.google_drive import drive_client, extract_folder_id, extract_file_id
from app.models.history import History, HistoryMedia
from app.schemas.history import (
    HistoryCreate,
    HistoryUpdate,
    HistoryInDB,
    HistoryOut,
    HistoryCategoryOut,
    HistoryMediaOut,
    HistoryGalleryOut,
)

router = APIRouter()


def _media_out(media: HistoryMedia) -> HistoryMediaOut | None:
    if media.photo_asset:
        return HistoryMediaOut(
            id=media.id,
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
            id=media.id,
            url=f"https://lh3.googleusercontent.com/d/{file_id}=w2000",
            thumb=f"https://lh3.googleusercontent.com/d/{file_id}=w600",
            caption=media.caption,
            source="drive",
        )
    return None


def _to_out(milestone: History) -> HistoryOut:
    media = [m for m in (_media_out(item) for item in milestone.media) if m]
    return HistoryOut(
        **{
            "id": milestone.id,
            "moment": milestone.moment,
            "title": milestone.title,
            "body": milestone.body,
            "image": milestone.image,
            "category": HistoryCategoryOut.model_validate(milestone.category)
            if milestone.category
            else None,
            "featured": milestone.featured,
            "mandate": milestone.mandate,
            "external_url": milestone.external_url,
            "external_label": milestone.external_label,
            "media": media,
            "has_drive_gallery": bool(milestone.drive_folder_url),
        }
    )


@router.get("/", status_code=200, response_model=List[HistoryOut])
def get(
    *, db: Session = Depends(deps.get_db, scope="function"),
    _ = Depends(deps.cms_cache)
) -> Any:
    return [_to_out(m) for m in crud.history.get_multi(db=db)]


@router.get("/{id}/gallery", status_code=200, response_model=HistoryGalleryOut)
async def get_gallery(
    *, id: int, db: Session = Depends(deps.get_db, scope="function"),
    _ = Depends(deps.cms_cache)
) -> Any:
    milestone = crud.history.get_published(db=db, id=id)
    if not milestone:
        raise HTTPException(status_code=404, detail="Marco não encontrado")

    media = [m for m in (_media_out(item) for item in milestone.media) if m]

    if milestone.drive_folder_url:
        folder_id = extract_folder_id(milestone.drive_folder_url)
        if folder_id:
            drive_images = await drive_client.list_folder_images(folder_id)
            next_id = max((m.id for m in media), default=0) + 1
            for offset, image in enumerate(drive_images):
                media.append(
                    HistoryMediaOut(
                        id=next_id + offset,
                        url=image.url,
                        thumb=image.thumb_url,
                        caption=image.caption,
                        source="drive",
                    )
                )

    return HistoryGalleryOut(id=milestone.id, title=milestone.title, media=media)
