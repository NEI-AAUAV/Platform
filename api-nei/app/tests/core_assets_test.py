import uuid

from app.core import assets
from app.core.config import settings

ASSET = uuid.UUID("d0073a1d-ee78-40cf-a07e-7e0307895d5b")


def test_asset_url_is_a_pure_directus_proxy(monkeypatch):
    monkeypatch.setattr(settings, "DIRECTUS_PUBLIC_URL", "http://cms/")
    assert assets.asset_url(ASSET) == f"http://cms/assets/{ASSET}"
