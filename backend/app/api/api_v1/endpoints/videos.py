from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Union

from app import crud
from app.api import deps
from app.schemas import VideoInDB, VideoUpdate, VideoCreate, VideoTagInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=Union[List[VideoInDB], VideoInDB])
def get_video(
    *, category = None, # list[str] testar
    video: int = None,
    page: int = None,
    db: Session = Depends(deps.get_db)
) -> Any:
    if video != None:
        return crud.video.get_video_by_id(db=db, id=video)
    elif category != None and page != None:
        return crud.video.get_videos_by_categories(db=db, categories=category, pagenumber=page)
    else:
        raise HTTPException(status_code=400, detail="Bad Request")

@router.get("/categories/", status_code=200, response_model=List[VideoTagInDB])
def get_categories(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """"
    Return the categories
    """
    return(crud.videotag.get_multi(db=db))