from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Union

from app.schemas.pagination import Page, PageParams

from app import crud
from app.api import deps
from app.schemas import VideoInDB, VideoUpdate, VideoCreate, VideoTagInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=Page[VideoInDB])
def get_video(
    *, page_params: PageParams = Depends(PageParams),
    tags: list[int] = Query(
        default=[], alias='tag[]',
        description="List of Tags"
    ),
    db: Session = Depends(deps.get_db)
) -> Any:

    all_cat = set(e.id for e in crud.videotag.get_multi(db=db))

    if not all_cat.issuperset(tags):
        raise HTTPException(status_code=400, detail="Invalid tag")

    total, items = crud.video.get_videos_by_categories(
        db=db, tags=tags, page=page_params.page, size=page_params.size)
    return Page.create(total, items, page_params)


@router.get("/{id}", status_code=200, response_model=VideoInDB)
def get_video(
    *, id: int, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.video.get(db=db, id=id)


@router.get("/categories/", status_code=200, response_model=List[VideoTagInDB])
def get_categories(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """"
    Return the categories
    """
    return (crud.videotag.get_multi(db=db))
