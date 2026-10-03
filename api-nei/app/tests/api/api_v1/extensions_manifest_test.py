"""`/extensions/manifest`: what the frontend uses to build extension navigation."""
import json
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings

URL = f"{settings.API_V1_STR}/extensions/manifest"


@pytest.fixture
def ext_dir(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, hide_container_extensions
) -> Path:
    monkeypatch.setenv("EXTENSIONS_DIR", str(tmp_path))
    monkeypatch.delenv("ENABLED_EXTENSIONS", raising=False)
    return tmp_path


def _manifest(base: Path, ext: str, content) -> None:
    (base / ext).mkdir()
    text = content if isinstance(content, str) else json.dumps(content)
    (base / ext / "manifest.json").write_text(text, encoding="utf-8")


def _nav(client: TestClient) -> list[dict]:
    r = client.get(URL)
    assert r.status_code == 200
    return r.json()["nav"]


def test_manifest_is_public_and_empty_without_extensions(
    client: TestClient, ext_dir: Path
) -> None:
    assert _nav(client) == []


def test_nav_entry_is_exposed_with_defaults(client: TestClient, ext_dir: Path) -> None:
    _manifest(ext_dir, "gala", {"name": "gala", "nav": [{"label": "Gala", "href": "/gala"}]})

    assert _nav(client) == [
        {
            "label": "Gala",
            "href": "/gala",
            "requiresScopes": [],
            "dynamicVisibility": None,
            "extension": "gala",
            "branded": False,
        }
    ]


def test_nav_entry_carries_scopes_visibility_and_branding(
    client: TestClient, ext_dir: Path
) -> None:
    _manifest(ext_dir, "rally", {"name": "rally", "nav": [{
        "label": "Rally", "href": "/rally", "requiresScopes": ["admin"],
        "dynamicVisibility": "has-event", "branded": 1}]})

    entry = _nav(client)[0]

    assert entry["requiresScopes"] == ["admin"]
    assert entry["dynamicVisibility"] == "has-event"
    assert entry["branded"] is True


def test_only_whitelisted_fields_leak_to_clients(client: TestClient, ext_dir: Path) -> None:
    _manifest(ext_dir, "gala", {"name": "gala", "secret": "x", "nav": [{
        "label": "Gala", "href": "/gala", "apiKey": "hunter2"}]})

    entry = _nav(client)[0]

    assert "apiKey" not in entry
    assert "secret" not in entry


def test_duplicate_entries_are_listed_once(client: TestClient, ext_dir: Path) -> None:
    item = {"label": "Gala", "href": "/gala"}
    _manifest(ext_dir, "gala", {"name": "gala", "nav": [item, item]})

    assert len(_nav(client)) == 1


def test_same_label_in_different_extensions_is_kept(client: TestClient, ext_dir: Path) -> None:
    item = {"label": "Home", "href": "/home"}
    _manifest(ext_dir, "a", {"name": "a", "nav": [item]})
    _manifest(ext_dir, "b", {"name": "b", "nav": [item]})

    assert sorted(e["extension"] for e in _nav(client)) == ["a", "b"]


def test_disabled_extensions_do_not_appear(
    client: TestClient, ext_dir: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setenv("ENABLED_EXTENSIONS", "gala")
    _manifest(ext_dir, "gala", {"name": "gala", "nav": [{"label": "G", "href": "/g"}]})
    _manifest(ext_dir, "rally", {"name": "rally", "nav": [{"label": "R", "href": "/r"}]})

    assert [e["extension"] for e in _nav(client)] == ["gala"]


def test_unreadable_manifest_does_not_break_the_others(
    client: TestClient, ext_dir: Path
) -> None:
    _manifest(ext_dir, "bad", "{ not json")
    _manifest(ext_dir, "ok", {"name": "ok", "nav": [{"label": "Ok", "href": "/ok"}]})

    assert [e["extension"] for e in _nav(client)] == ["ok"]


def test_manifest_without_nav_contributes_nothing(client: TestClient, ext_dir: Path) -> None:
    _manifest(ext_dir, "a", {"name": "a", "nav": None})
    _manifest(ext_dir, "b", {"name": "b"})

    assert _nav(client) == []
