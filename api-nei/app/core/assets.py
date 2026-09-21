"""Public URLs for files uploaded through Directus.

Asset UUIDs are resolved through Directus' public asset proxy. This module is
safe to call from ORM presentation properties: it performs no database or
network I/O and keeps no worker-local cache.
"""
import uuid

from app.core.config import settings

def asset_url(asset_id: uuid.UUID) -> str:
    """Return the stable public Directus URL for an asset UUID."""
    return f"{settings.DIRECTUS_PUBLIC_URL}assets/{asset_id}"
