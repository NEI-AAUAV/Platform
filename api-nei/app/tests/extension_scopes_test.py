"""Extension scope registry and manifest discovery contracts."""
import json
from pathlib import Path

import pytest

from app.core import extension_scopes as es
from app.core.extension_scopes import ExtensionScopeRegistry as Registry


@pytest.fixture(autouse=True)
def _clean_registry():
    Registry.clear()
    yield
    Registry.clear()


def _write_manifest(base: Path, ext: str, content) -> None:
    folder = base / ext
    folder.mkdir(parents=True)
    text = content if isinstance(content, str) else json.dumps(content)
    (folder / "manifest.json").write_text(text, encoding="utf-8")


@pytest.fixture
def ext_dir(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, hide_container_extensions
) -> Path:
    monkeypatch.setenv("EXTENSIONS_DIR", str(tmp_path))
    monkeypatch.delenv("ENABLED_EXTENSIONS", raising=False)
    return tmp_path


# --- registry ---------------------------------------------------------------


def test_register_scope_exposes_it_in_scope_dict() -> None:
    Registry.register_scope("gala", "manager-gala", "Manage gala")

    assert es.load_extension_scopes() == {"manager-gala": "Manage gala"}


def test_same_scope_name_in_two_extensions_is_kept_separately() -> None:
    Registry.register_scope("a", "admin", "A admin")
    Registry.register_scope("b", "admin", "B admin")

    assert len(Registry.get_all_scopes()) == 2
    assert [s.description for s in Registry.get_scopes_for_extension("b")] == ["B admin"]


def test_registering_twice_overwrites_instead_of_duplicating() -> None:
    Registry.register_scope("a", "s", "old")
    Registry.register_scope("a", "s", "new")

    assert Registry.get_scope_dict() == {"s": "new"}


def test_get_all_scopes_returns_a_copy() -> None:
    Registry.register_scope("a", "s", "d")

    Registry.get_all_scopes().clear()

    assert len(Registry.get_all_scopes()) == 1


def test_clear_resets_scopes_and_initialized_flag() -> None:
    Registry.register_scope("a", "s", "d")
    Registry.mark_initialized()

    Registry.clear()

    assert Registry.get_all_scopes() == {}
    assert not Registry.is_initialized()


# --- ENABLED_EXTENSIONS -----------------------------------------------------


def test_enabled_extensions_unset_means_load_all(monkeypatch) -> None:
    monkeypatch.delenv("ENABLED_EXTENSIONS", raising=False)
    assert es._get_enabled_extensions() is None


@pytest.mark.parametrize("raw", ["", "   "])
def test_enabled_extensions_blank_means_load_none(monkeypatch, raw) -> None:
    monkeypatch.setenv("ENABLED_EXTENSIONS", raw)
    assert es._get_enabled_extensions() == set()


def test_enabled_extensions_is_trimmed_and_ignores_empty_items(monkeypatch) -> None:
    monkeypatch.setenv("ENABLED_EXTENSIONS", " gala , rally ,, ")
    assert es._get_enabled_extensions() == {"gala", "rally"}


# --- manifest loading -------------------------------------------------------


def test_loads_scopes_from_every_manifest(ext_dir: Path) -> None:
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": [
        {"name": "manager-gala", "description": "Gala manager"}]})
    _write_manifest(ext_dir, "rally", {"name": "rally", "scopes": [
        {"name": "rally-staff", "description": "Staff"}]})

    es.load_scopes_from_manifests()

    assert es.load_extension_scopes() == {
        "manager-gala": "Gala manager", "rally-staff": "Staff"}
    assert Registry.is_initialized()


def test_scope_description_defaults_to_scope_name(ext_dir: Path) -> None:
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": [{"name": "s"}]})

    es.load_scopes_from_manifests()

    assert es.load_extension_scopes() == {"s": "s"}


def test_only_enabled_extensions_are_loaded(ext_dir: Path, monkeypatch) -> None:
    monkeypatch.setenv("ENABLED_EXTENSIONS", "gala")
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": [{"name": "g"}]})
    _write_manifest(ext_dir, "rally", {"name": "rally", "scopes": [{"name": "r"}]})

    es.load_scopes_from_manifests()

    assert list(es.load_extension_scopes()) == ["g"]


def test_empty_enabled_list_loads_nothing(ext_dir: Path, monkeypatch) -> None:
    monkeypatch.setenv("ENABLED_EXTENSIONS", "")
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": [{"name": "g"}]})

    es.load_scopes_from_manifests()

    assert es.load_extension_scopes() == {}
    assert not Registry.is_initialized()


@pytest.mark.parametrize(
    "manifest",
    [
        {"scopes": [{"name": "orphan"}]},  # no extension name
        "{ this is not json",              # unparsable
    ],
)
def test_bad_manifest_is_skipped_without_raising(ext_dir: Path, manifest) -> None:
    _write_manifest(ext_dir, "bad", manifest)
    _write_manifest(ext_dir, "ok", {"name": "ok", "scopes": [{"name": "fine"}]})

    es.load_scopes_from_manifests()

    assert list(es.load_extension_scopes()) == ["fine"]


def test_scope_without_name_is_skipped(ext_dir: Path) -> None:
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": [
        {"description": "nameless"}, {"name": "good"}]})

    es.load_scopes_from_manifests()

    assert list(es.load_extension_scopes()) == ["good"]


def test_null_scopes_field_is_treated_as_empty(ext_dir: Path) -> None:
    _write_manifest(ext_dir, "gala", {"name": "gala", "scopes": None})

    es.load_scopes_from_manifests()

    assert es.load_extension_scopes() == {}
    assert not Registry.is_initialized()


def test_directories_without_manifest_are_ignored(ext_dir: Path) -> None:
    (ext_dir / "empty").mkdir()

    assert es._iter_extension_manifests([str(ext_dir)]) == []


def test_missing_base_dir_is_ignored() -> None:
    assert es._iter_extension_manifests(["/definitely/not/here", ""]) == []
