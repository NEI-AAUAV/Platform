from typing import Generator

from fastapi import Response
from sqlalchemy.exc import SQLAlchemyError
from email_validator import caching_resolver

from app.db.session import SessionLocal


# Create the dns resolver to use for email validation (Supports caching).
email_resolver = caching_resolver(timeout=15)


# Dependency that sets up a database transaction for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        raise
    finally:
        db.close()


class CacheControlHeader:
    # Short periods (`max-age` of five minutes (300s) e.g.) can already improve user experience with minimal risk.
    # Add `must-revalidate` to ensure that browsers do not use a stale version of the asset after the `max-age` has expired.
    # This will benefit visitors who click links returning them to previously visited pages.
    #
    # The `private` attribute indicates that assets should not be stored by any proxies or CDNs, but may be cached by the client.
    # This allows browsers to cache personalised content, as the cached asset will not be shared across multiple visitors.

    def __init__(self, max_age: int = 3600):
        self.max_age = max_age

    def __call__(self, response: Response):
        response.headers[
            "Cache-Control"
        ] = f"private, max-age={self.max_age}, must-revalidate"
        return response


short_cache = CacheControlHeader(max_age=300)  # 5 minutes
long_cache = CacheControlHeader(max_age=86400)  # 1 day
