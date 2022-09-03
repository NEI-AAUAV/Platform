from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import NewsInDB, NewsCategories, NewsCreate, NewsUpdate

router = APIRouter()


@router.get("/", status_code=200, response_model=List[NewsInDB])
def get_video(
    *, category: list[str] = None,
    article: int = None,
    page: int = None,
    db: Session = Depends(deps.get_db)
) -> Any:
    print(category)
    print(article)
    print(page)
    if article != None:
        return crud.news.get_news_by_id(db=db, id=article)
    elif page != None:
        return crud.news.get_news_by_categories(db=db, categories=category, pagenumber=page)
    else:
        raise HTTPException(status_code=400, detail="Bad Request")

@router.get("/categories/", status_code=200, response_model=List[NewsCategories])
def get_categories(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """"
    Return the categories
    """
    return(crud.news.get_news_categories(db=db))