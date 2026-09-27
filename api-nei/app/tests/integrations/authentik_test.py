import asyncio

import httpx
import pytest

from app.core.config import settings
from app.integrations.authentik import AuthentikClient, AuthentikError, group_role_name


def _run(client: AuthentikClient) -> list[dict[str, object]]:
    return asyncio.run(client.list_groups())


def test_list_groups_success(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")

    def handler(request: httpx.Request) -> httpx.Response:
        assert request.headers["Authorization"] == "Bearer secret"
        return httpx.Response(
            200,
            json={
                "results": [
                    {"pk": "group", "name": "Managers", "users_obj": [{"uid": "sub"}]}
                ],
                "pagination": {"next": None},
            },
        )

    groups = _run(AuthentikClient(httpx.MockTransport(handler)))
    assert groups == [{"pk": "group", "name": "Managers", "member_subs": ["sub"]}]


@pytest.mark.parametrize("upstream_status", [500, 503])
def test_upstream_server_error_is_safe_bad_gateway(monkeypatch, upstream_status: int) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")
    client = AuthentikClient(
        httpx.MockTransport(lambda _: httpx.Response(upstream_status, text="private"))
    )
    with pytest.raises(AuthentikError) as exc:
        _run(client)
    assert (exc.value.status_code, exc.value.public_detail) == (
        502,
        "Authentik is unavailable",
    )


def test_missing_configuration_is_service_unavailable(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "")
    client = AuthentikClient(httpx.MockTransport(lambda _: httpx.Response(200)))

    with pytest.raises(AuthentikError) as exc:
        _run(client)
    assert exc.value.status_code == 503


def test_timeout_is_gateway_timeout(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")

    def timeout(request: httpx.Request) -> httpx.Response:
        raise httpx.ReadTimeout("slow", request=request)

    client = AuthentikClient(httpx.MockTransport(timeout))

    with pytest.raises(AuthentikError) as exc:
        _run(client)
    assert exc.value.status_code == 504


def test_invalid_json_is_bad_gateway(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")
    client = AuthentikClient(
        httpx.MockTransport(lambda _: httpx.Response(200, text="not-json"))
    )
    with pytest.raises(AuthentikError) as exc:
        _run(client)
    assert exc.value.status_code == 502


@pytest.mark.parametrize(
    "group_name,role",
    [
        ("admin", "admin"),
        ("nei-admin", "admin"),
        ("  NEI-Manager-Arraial ", "manager-arraial"),
        ("authentik Admins", "authentik admins"),
    ],
)
def test_group_role_name(group_name: str, role: str) -> None:
    assert group_role_name(group_name) == role


def test_get_group_name(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")

    def handler(request: httpx.Request) -> httpx.Response:
        assert request.url.path.endswith("/api/v3/core/groups/abc/")
        return httpx.Response(200, json={"pk": "abc", "name": "nei-admin"})

    client = AuthentikClient(httpx.MockTransport(handler))

    assert asyncio.run(client.get_group_name("abc")) == "nei-admin"


def test_get_group_name_without_a_name_is_bad_gateway(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")
    client = AuthentikClient(httpx.MockTransport(lambda _: httpx.Response(200, json={"pk": "abc"})))

    with pytest.raises(AuthentikError) as exc:
        asyncio.run(client.get_group_name("abc"))
    assert exc.value.status_code == 502
