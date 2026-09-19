"""Public URLs for files uploaded through Directus.

When `ASSETS_PUBLIC_URL` (the public base of the R2 bucket, including the
Directus storage root, e.g. `https://cdn.example.com/cms`) is set and the file
lives in the R2 storage, the URL points straight at the object. Otherwise, or
if the lookup fails, it falls back to the Directus proxy
`{DIRECTUS_PUBLIC_URL}assets/{uuid}`, which always works.
"""
import logging
import time
import uuid
from typing import Dict, Optional, Tuple

from sqlalchemy import text

from app.core.config import settings

logger = logging.getLogger(__name__)

_CACHE_TTL_SECONDS = 300
# asset id -> (expires_at, direct url or None)
_cache: Dict[uuid.UUID, Tuple[float, Optional[str]]] = {}


def _proxy_url(asset_id: uuid.UUID) -> str:
    return f"{settings.DIRECTUS_PUBLIC_URL}assets/{asset_id}"


def _lookup_direct_url(asset_id: uuid.UUID) -> Optional[str]:
    # Imported here: app.db.session builds the engine at import time.
    from app.db.session import SessionLocal

    db = SessionLocal()
    try:
        row = db.execute(
            text(
                "SELECT storage, filename_disk FROM directus.directus_files WHERE id = :id"
            ),
            {"id": asset_id},
        ).first()
    finally:
        db.close()
    if row is None or row.storage != settings.ASSETS_STORAGE or not row.filename_disk:
        return None
    return f"{settings.ASSETS_PUBLIC_URL.rstrip('/')}/{row.filename_disk}"


def asset_url(asset_id: uuid.UUID) -> str:
    if not settings.ASSETS_PUBLIC_URL:
        return _proxy_url(asset_id)

    now = time.monotonic()
    cached = _cache.get(asset_id)
    if cached is None or cached[0] < now:
        try:
            direct = _lookup_direct_url(asset_id)
        except Exception:
            logger.warning(
                "Could not resolve direct URL for asset %s; using Directus proxy",
                asset_id,
                exc_info=True,
            )
            direct = None
        cached = (now + _CACHE_TTL_SECONDS, direct)
        _cache[asset_id] = cached
    return cached[1] or _proxy_url(asset_id)
