from app.schemas.pagination import Page, PageParams
from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import NewsInDB, NewsCategories
from app.schemas.news import CategoryEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=Page[NewsInDB])
def get_news_list(
    *, page_params: PageParams = Depends(PageParams),
    _ = Depends(deps.short_cache),
    categories: List[str] = Query(
        default=[], alias='category[]',
        description="List of categories",
    ),
    db: Session = Depends(deps.get_db)
) -> Any:
    # Validate against the category vocabulary, not against what happens to be
    # published: a real category with nothing published yet is an empty page,
    # not a bad request.
    if not {c.value for c in CategoryEnum}.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    total, items = crud.news.get_news_by_categories(
        db=db, categories=categories, page=page_params.page, size=page_params.size)
    
    return Page.create(total, items, page_params)


@router.get("/category", status_code=200, response_model=NewsCategories)
def get_news_categories(
    *, db: Session = Depends(deps.get_db),
    _ = Depends(deps.long_cache),
) -> Any:
    """
    Return the categories
    """
    data = crud.news.get_news_categories(db=db)
    data = [e[0].value for e in data]
    return {"data": data}


@router.get("/{id}", status_code=200, response_model=NewsInDB)
def get_news(
    *, id: int, db: Session = Depends(deps.get_db),
    _ = Depends(deps.long_cache),
) -> Any:

    item = crud.news.get(db=db, id=id)
    # Drafts are indistinguishable from missing items for anonymous callers.
    if item is None or not item.public:
        raise HTTPException(status_code=404, detail="Item not found")
    else:
        return item
