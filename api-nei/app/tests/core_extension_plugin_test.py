"""Lifecycle + isolation guarantees of the extension plugin manager."""

from unittest.mock import MagicMock

import pytest
from fastapi import FastAPI

from app.core import extension_plugin as ep
from app.core.extension_plugin import ExtensionPlugin, ExtensionPluginManager


class _Plugin(ExtensionPlugin):
    def __init__(self, name: str = "demo", scopes: dict[str, str] | None = None):
        super().__init__(name)
        self._scopes = scopes if scopes is not None else {}
        self.calls: list[str] = []

    def register_scopes(self) -> dict[str, str]:
        return self._scopes

    def register_routes(self, app: FastAPI) -> None:
        self.calls.append("routes")

    def register_middleware(self, app: FastAPI) -> None:
        self.calls.append("middleware")

    def register_startup_events(self, app: FastAPI) -> None:
        self.calls.append("startup")

    def register_shutdown_events(self, app: FastAPI) -> None:
        self.calls.append("shutdown")


class _Exploding(_Plugin):
    def register_routes(self, app):
        raise RuntimeError("boom")

    def register_middleware(self, app):
        raise RuntimeError("boom")

    def register_startup_events(self, app):
        raise RuntimeError("boom")


@pytest.fixture
def registry(monkeypatch: pytest.MonkeyPatch) -> MagicMock:
    mock = MagicMock()
    monkeypatch.setattr(
        "app.core.extension_scopes.ExtensionScopeRegistry", mock, raising=False
    )
    return mock


def test_base_class_is_abstract() -> None:
    with pytest.raises(TypeError):
        ExtensionPlugin("x")  # type: ignore[abstract]


def test_plugin_starts_uninitialized_and_exposes_name() -> None:
    plugin = _Plugin("gala")

    assert plugin.name == "gala"
    assert plugin.is_initialized is False

    plugin.mark_initialized()

    assert plugin.is_initialized is True


def test_default_hooks_are_noops() -> None:
    class Minimal(ExtensionPlugin):
        def register_scopes(self):
            return {}

    plugin, app = Minimal("m"), FastAPI()

    plugin.register_routes(app)
    plugin.register_middleware(app)
    plugin.register_startup_events(app)
    plugin.register_shutdown_events(app)


def test_register_and_get_plugin() -> None:
    manager, plugin = ExtensionPluginManager(), _Plugin("gala")

    manager.register_plugin(plugin)

    assert manager.get_plugin("gala") is plugin
    assert manager.get_plugin("missing") is None


def test_registering_same_name_overwrites_previous() -> None:
    manager, first, second = ExtensionPluginManager(), _Plugin("a"), _Plugin("a")
    manager.register_plugin(first)

    manager.register_plugin(second)

    assert manager.get_plugin("a") is second


def test_get_all_plugins_returns_a_copy() -> None:
    manager = ExtensionPluginManager()
    manager.register_plugin(_Plugin("a"))

    snapshot = manager.get_all_plugins()
    snapshot.clear()

    assert set(manager.get_all_plugins()) == {"a"}


def test_initialize_unknown_plugin_returns_false() -> None:
    assert ExtensionPluginManager().initialize_plugin("nope") is False


def test_initialize_registers_each_scope_under_extension_name(registry) -> None:
    manager = ExtensionPluginManager()
    plugin = _Plugin("gala", {"manager": "Manage", "viewer": "View"})
    manager.register_plugin(plugin)

    assert manager.initialize_plugin("gala") is True

    assert plugin.is_initialized
    registry.register_scope.assert_any_call("gala", "manager", "Manage")
    registry.register_scope.assert_any_call("gala", "viewer", "View")
    assert registry.register_scope.call_count == 2


def test_initialize_without_scopes_does_not_touch_registry(registry) -> None:
    manager = ExtensionPluginManager()
    manager.register_plugin(_Plugin("gala"))

    assert manager.initialize_plugin("gala") is True

    registry.register_scope.assert_not_called()


def test_initialize_failure_is_contained_and_leaves_plugin_uninitialized(
    registry,
) -> None:
    registry.register_scope.side_effect = RuntimeError("registry down")
    manager, plugin = ExtensionPluginManager(), _Plugin("gala", {"s": "d"})
    manager.register_plugin(plugin)

    assert manager.initialize_plugin("gala") is False
    assert plugin.is_initialized is False


def test_initialize_all_continues_after_a_failing_plugin(registry) -> None:
    class BadScopes(_Plugin):
        def register_scopes(self):
            raise RuntimeError("bad")

    manager = ExtensionPluginManager()
    bad, good = BadScopes("bad"), _Plugin("good")
    manager.register_plugin(bad)
    manager.register_plugin(good)

    manager.initialize_all_plugins()

    assert not bad.is_initialized
    assert good.is_initialized
    assert manager._initialized is True


def test_hooks_only_run_for_initialized_plugins() -> None:
    manager, ready, cold = ExtensionPluginManager(), _Plugin("ready"), _Plugin("cold")
    ready.mark_initialized()
    manager.register_plugin(ready)
    manager.register_plugin(cold)
    app = FastAPI()

    manager.register_plugin_routes(app)
    manager.register_plugin_middleware(app)
    manager.register_plugin_events(app)

    assert ready.calls == ["routes", "middleware", "startup", "shutdown"]
    assert cold.calls == []


def test_failing_plugin_hooks_do_not_block_other_plugins() -> None:
    manager, bad, good = ExtensionPluginManager(), _Exploding("bad"), _Plugin("good")
    for p in (bad, good):
        p.mark_initialized()
        manager.register_plugin(p)
    app = FastAPI()

    manager.register_plugin_routes(app)
    manager.register_plugin_middleware(app)
    manager.register_plugin_events(app)

    assert good.calls == ["routes", "middleware", "startup", "shutdown"]


def test_global_manager_is_a_manager_instance() -> None:
    assert isinstance(ep.plugin_manager, ExtensionPluginManager)
