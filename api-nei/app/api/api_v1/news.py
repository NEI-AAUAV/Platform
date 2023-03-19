from app.schemas.pagination import Page, PageParams
from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import NewsInDB, NewsCategories

router = APIRouter()


@router.get("/", status_code=200, response_model=Page[NewsInDB])
def get_news_list(
    *, page_params: PageParams = Depends(PageParams), response: Response,
    categories: List[str] = Query(
        default=[], alias='category[]',
        description="List of categories",
    ),
    db: Session = Depends(deps.get_db)
) -> Any:
    all_categories = set(
        e[0].value for e in crud.news.get_news_categories(db=db))

    if not all_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    total, items = crud.news.get_news_by_categories(
        db=db, categories=categories, page=page_params.page, size=page_params.size)
    
    response.headers["cache-control"] = "private, max-age=86400, no-cache"
    return Page.create(total, items, page_params)


@router.get("/category", status_code=200, response_model=NewsCategories)
def get_news_categories(
    *, db: Session = Depends(deps.get_db), response: Response,
) -> Any:
    """
    Return the categories
    """
    response.headers["cache-control"] = "private, max-age=2592000, no-cache"
    data = crud.news.get_news_categories(db=db)
    data = [e[0].value for e in data]
    return {"data": data}


@router.get("/{id}", status_code=200, response_model=NewsInDB)
def get_news(
    *, id: int, db: Session = Depends(deps.get_db), response: Response,
) -> Any:
    response.headers["cache-control"] = "private, max-age=86400, no-cache"

    item = crud.news.get(db=db, id=id)
    if item == None:
        raise HTTPException(status_code=404, detail="Item not found")
    else:
        return item
