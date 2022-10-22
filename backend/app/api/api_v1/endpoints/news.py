from app.schemas.pagination import Page, PageParams
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import NewsInDB, NewsCategories

router = APIRouter()


@router.get("/", status_code=200, response_model=Page[NewsInDB])
def get_news_list(
    *, page_params: PageParams = Depends(PageParams),
    categories: List[str] = Query(
        default=[], alias='category',
        description="List of categories",
    ),
    db: Session = Depends(deps.get_db)
) -> Any:
    all_categories = set(crud.news.get_news_categories(db=db))

    if not all_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    items = crud.news.get_news_by_categories(db=db, categories=categories,
                                             page=page_params.page, size=page_params.size)
    return Page.create(items, page_params)


@router.get("/{news_id}", status_code=200, response_model=NewsInDB)
def get_news(
    *, news_id: int, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.news.get_news_by_id(db=db, id=news_id)


@router.get("/categories/", status_code=200, response_model=NewsCategories)
def get_news_categories(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """"
    Return the categories
    """
    data = crud.news.get_news_categories(db=db)
    return {"data": data}
