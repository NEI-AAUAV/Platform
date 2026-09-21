import asyncio

import httpx
import pytest

from app.core.config import settings
from app.integrations.authentik import AuthentikClient, AuthentikError


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
    with pytest.raises(AuthentikError) as exc:
        _run(AuthentikClient(httpx.MockTransport(lambda _: httpx.Response(200))))
    assert exc.value.status_code == 503


def test_timeout_is_gateway_timeout(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")

    def timeout(request: httpx.Request) -> httpx.Response:
        raise httpx.ReadTimeout("slow", request=request)

    with pytest.raises(AuthentikError) as exc:
        _run(AuthentikClient(httpx.MockTransport(timeout)))
    assert exc.value.status_code == 504


def test_invalid_json_is_bad_gateway(monkeypatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")
    client = AuthentikClient(
        httpx.MockTransport(lambda _: httpx.Response(200, text="not-json"))
    )
    with pytest.raises(AuthentikError) as exc:
        _run(client)
    assert exc.value.status_code == 502
