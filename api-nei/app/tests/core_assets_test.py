import uuid

import pytest

from app.core import assets
from app.core.config import settings

ASSET = uuid.UUID("d0073a1d-ee78-40cf-a07e-7e0307895d5b")


@pytest.fixture(autouse=True)
def _reset(monkeypatch):
    assets._cache.clear()
    monkeypatch.setattr(settings, "DIRECTUS_PUBLIC_URL", "http://cms/")
    yield
    assets._cache.clear()


def test_uses_directus_proxy_when_public_url_unset(monkeypatch):
    monkeypatch.setattr(settings, "ASSETS_PUBLIC_URL", "")
    assert assets.asset_url(ASSET) == f"http://cms/assets/{ASSET}"


def test_returns_direct_url_and_caches(monkeypatch):
    monkeypatch.setattr(settings, "ASSETS_PUBLIC_URL", "https://cdn/cms")
    calls = []

    def lookup(asset_id):
        calls.append(asset_id)
        return f"https://cdn/cms/{asset_id}.jpg"

    monkeypatch.setattr(assets, "_lookup_direct_url", lookup)
    assert assets.asset_url(ASSET) == f"https://cdn/cms/{ASSET}.jpg"
    assets.asset_url(ASSET)
    assert len(calls) == 1


def test_falls_back_to_proxy_when_lookup_fails(monkeypatch):
    monkeypatch.setattr(settings, "ASSETS_PUBLIC_URL", "https://cdn/cms")

    def boom(_):
        raise RuntimeError("no grant")

    monkeypatch.setattr(assets, "_lookup_direct_url", boom)
    assert assets.asset_url(ASSET) == f"http://cms/assets/{ASSET}"
