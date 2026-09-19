from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models.team import TeamMandate, TeamMember, TeamSection
from app.models.user import User
from app.tests.conftest import SessionTesting

BASE = f"{settings.API_V1_STR}/team"


def _seed(db: SessionTesting) -> None:
    user = User(
        name="Ana",
        surname="Silva",
        github="https://github.com/ana",
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add_all([user, TeamMandate(mandate="2026/27")])
    db.flush()
    late = TeamSection(mandate="2026/27", name="Vogais", weight=1)
    first = TeamSection(mandate="2026/27", name="Coordenação", weight=0)
    db.add_all([late, first])
    db.flush()
    db.add_all(
        [
            TeamMember(section_id=first.id, user_id=user.id, name="Ana S.", role="Coordenadora", weight=0),
            TeamMember(section_id=first.id, name="João", role="Vice", weight=1),
        ]
    )
    db.commit()


def test_mandates_listed(client: TestClient, db: SessionTesting) -> None:
    _seed(db)
    r = client.get(f"{BASE}/mandate/")
    assert r.status_code == 200
    assert "2026/27" in r.json()["data"]


def test_tree_is_mandate_sections_members(client: TestClient, db: SessionTesting) -> None:
    _seed(db)
    r = client.get(f"{BASE}/mandate/2026/27")
    assert r.status_code == 200
    body = r.json()
    assert body["mandate"] == "2026/27"
    assert "categories" not in body
    assert [s["name"] for s in body["sections"]] == ["Coordenação", "Vogais"]
    members = body["sections"][0]["members"]
    assert [m["name"] for m in members] == ["Ana S.", "João"]
    assert members[0]["user"] == {"linkedin": None, "github": "https://github.com/ana"}
    assert members[1]["user"] is None


def test_removed_endpoints_are_gone(client: TestClient) -> None:
    assert client.get(f"{BASE}/role/").status_code == 404
    assert client.get(f"{BASE}/colaborator/").status_code == 404
