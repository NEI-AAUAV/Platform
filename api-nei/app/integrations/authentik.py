"""Small, typed client for the Authentik administration API."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import httpx

from app.core.config import settings


@dataclass
class AuthentikError(Exception):
    status_code: int
    public_detail: str


_INVALID_RESPONSE = "Authentik returned an invalid response"


class AuthentikClient:
    def __init__(self, transport: httpx.AsyncBaseTransport | None = None) -> None:
        self._transport = transport
        self._client: httpx.AsyncClient | None = None

    def start(self) -> None:
        """Build the client. Sync: constructing an AsyncClient does no I/O."""
        if self._client is None:
            self._client = httpx.AsyncClient(
                verify=settings.OIDC_VERIFY_SSL,
                timeout=httpx.Timeout(10.0),
                transport=self._transport,
            )

    async def close(self) -> None:
        if self._client is not None:
            await self._client.aclose()
            self._client = None

    def _headers(self) -> dict[str, str]:
        if not settings.AUTHENTIK_TOKEN:
            raise AuthentikError(503, "Authentik admin API is not configured")
        return {"Authorization": f"Bearer {settings.AUTHENTIK_TOKEN}"}

    async def _request(self, method: str, url: str, **kwargs: Any) -> httpx.Response:
        try:
            self.start()
            assert self._client is not None
            response = await self._client.request(
                method, url, headers=self._headers(), **kwargs
            )
        except httpx.TimeoutException as exc:
            raise AuthentikError(504, "Authentik request timed out") from exc
        except httpx.RequestError as exc:
            raise AuthentikError(502, "Authentik is unavailable") from exc
        if response.status_code >= 500:
            raise AuthentikError(502, "Authentik is unavailable")
        if response.status_code == 404:
            raise AuthentikError(404, "Authentik object not found")
        if response.is_error:
            raise AuthentikError(502, "Authentik rejected the request")
        return response

    @staticmethod
    def _json(response: httpx.Response) -> dict[str, Any]:
        try:
            data = response.json()
        except ValueError as exc:
            raise AuthentikError(502, _INVALID_RESPONSE) from exc
        if not isinstance(data, dict):
            raise AuthentikError(502, _INVALID_RESPONSE)
        return data

    async def find_user_pk(self, authentik_sub: str) -> int:
        response = await self._request(
            "GET",
            f"{settings.AUTHENTIK_URL}/api/v3/core/users/",
            params={"uuid": authentik_sub},
        )
        results = self._json(response).get("results", [])
        if not results:
            raise AuthentikError(404, "Authentik user not found")
        try:
            return int(results[0]["pk"])
        except (KeyError, TypeError, ValueError) as exc:
            raise AuthentikError(502, _INVALID_RESPONSE) from exc

    async def list_groups(self) -> list[dict[str, Any]]:
        url: str | None = f"{settings.AUTHENTIK_URL}/api/v3/core/groups/"
        params: dict[str, Any] = {"include_users": "true", "page_size": 100}
        groups: list[dict[str, Any]] = []
        while url:
            response = await self._request("GET", url, params=params)
            data = self._json(response)
            for group in data.get("results", []):
                groups.append(
                    {
                        "pk": group["pk"],
                        "name": group["name"],
                        "member_subs": [
                            user["uid"] for user in group.get("users_obj", [])
                        ],
                    }
                )
            url = data.get("pagination", {}).get("next") or None
            params = {}
        return groups

    async def set_group_membership(
        self, group_pk: str, user_pk: int, *, add: bool
    ) -> None:
        action = "add_user" if add else "remove_user"
        await self._request(
            "POST",
            f"{settings.AUTHENTIK_URL}/api/v3/core/groups/{group_pk}/{action}/",
            json={"pk": user_pk},
        )


authentik_client = AuthentikClient()
