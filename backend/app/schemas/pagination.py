from __future__ import annotations
from dataclasses import dataclass
import math

from pydantic import BaseModel
from pydantic.generics import GenericModel

from fastapi import Query
from typing import Generic, Optional, TypeVar, Sequence


@dataclass
class PageRawParams(BaseModel):
    limit: int
    offset: int


class PageParams(BaseModel):
    page: int = Query(1, ge=1, description="Page number")
    size: int = Query(20, ge=1, le=100, description="Page size")

    def to_raw_params(self) -> PageRawParams:
        return PageRawParams(
            limit=self.size,
            offset=self.size * (self.page - 1),
        )


T = TypeVar("T")

class Page(GenericModel, Generic[T]):
    items: Sequence[T]
    total: int = 0
    page: int
    size: int
    first: Optional[int] = None
    last: Optional[int] = None
    prev: Optional[int] = None
    next: Optional[int] = None

    @classmethod
    def create(
        cls,
        items: Sequence[T],
        params: PageParams,
    ) -> Page[T]:
        first = last = prev = next = None
        total = len(items)

        if items:
            first = 1
            last = math.ceil(total / params.size)
            prev = None if params.page <= first else params.page - 1
            next = None if params.page >= last else params.page + 1

        return cls(
            items=items, total=total,
            page=params.page, size=params.size,
            first=first, last=last,
            prev=prev, next=next
        )