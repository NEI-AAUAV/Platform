"""HTTP contract of the faina / senior / team-member admin CRUD routes.

Contract points covered for every write route:
* anonymous -> 401, authenticated without MANAGER_NEI -> 403
* unknown id -> 404, valid write -> persisted and echoed back
"""

from datetime import datetime

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import User
from app.models.faina.faina import Faina
from app.models.faina.faina_member import FainaMember
from app.models.faina.faina_role import FainaRole
from app.models.senior.senior import Senior
from app.models.senior.senior_student import SeniorStudent
from app.models.team import TeamMandate, TeamMember, TeamSection
from app.schemas.user.user import ScopeEnum
from app.tests.api.api_v1._utils import auth_data
from app.tests.conftest import SessionTesting

API = settings.API_V1_STR
MANAGER = auth_data(scopes=[ScopeEnum.MANAGER_NEI])
NOBODY = auth_data()
MISSING = 999_999

WRITE_ONLY_AUTH = [(None, 401), (NOBODY, 403)]


def _user(db: SessionTesting, name: str = "Ana") -> User:
    user = User(
        name=name,
        surname="Silva",
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(user)
    db.flush()
    return user


# ---------------------------------------------------------------- faina role


def _role(db: SessionTesting, name: str = "Mestre", weight: int = 1) -> FainaRole:
    role = FainaRole(name=name, weight=weight)
    db.add(role)
    db.flush()
    return role


@pytest.mark.parametrize("client", [None], indirect=True)
def test_faina_roles_are_public_and_listed(client: TestClient, db: SessionTesting) -> None:
    _role(db, "Mestre")
    db.commit()

    r = client.get(f"{API}/faina/role/")

    assert r.status_code == 200
    assert "Mestre" in [role["name"] for role in r.json()]


@pytest.mark.parametrize("client", [None], indirect=True)
def test_faina_role_by_id_and_404(client: TestClient, db: SessionTesting) -> None:
    role = _role(db)
    db.commit()

    ok = client.get(f"{API}/faina/role/{role.id}")
    missing = client.get(f"{API}/faina/role/{MISSING}")

    assert ok.status_code == 200
    assert ok.json()["id"] == role.id
    assert missing.status_code == 404
    assert missing.json()["detail"] == "Faina Role Not Found"


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_and_updates_faina_role(client: TestClient) -> None:
    created = client.post(f"{API}/faina/role/", json={"name": "Padrinho", "weight": 3})
    assert created.status_code == 201
    role_id = created.json()["id"]

    updated = client.put(f"{API}/faina/role/{role_id}", json={"weight": 9})

    assert updated.status_code == 200
    assert updated.json() == {"id": role_id, "name": "Padrinho", "weight": 9}


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_update_unknown_faina_role_is_404(client: TestClient) -> None:
    r = client.put(f"{API}/faina/role/{MISSING}", json={"weight": 1})

    assert r.status_code == 404


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_faina_role_name_is_length_limited(client: TestClient) -> None:
    r = client.post(f"{API}/faina/role/", json={"name": "x" * 21})

    assert r.status_code == 422


@pytest.mark.parametrize(
    "client,status_code", WRITE_ONLY_AUTH, indirect=["client"]
)
def test_faina_role_writes_require_manager(client: TestClient, status_code: int) -> None:
    assert client.post(f"{API}/faina/role/", json={"name": "x"}).status_code == status_code
    assert client.put(f"{API}/faina/role/1", json={"weight": 1}).status_code == status_code


# --------------------------------------------------------------- faina member


def _faina(db: SessionTesting, mandate: str = "2025/26") -> Faina:
    faina = Faina(mandate=mandate)
    db.add(faina)
    db.flush()
    return faina


@pytest.mark.parametrize("client", [None], indirect=True)
def test_faina_member_by_id_and_404(client: TestClient, db: SessionTesting) -> None:
    faina, role = _faina(db), _role(db)
    member = FainaMember(faina_id=faina.id, role_id=role.id, name="Zé")
    db.add(member)
    db.commit()

    ok = client.get(f"{API}/faina/member/{member.id}")
    listing = client.get(f"{API}/faina/member/")
    missing = client.get(f"{API}/faina/member/{MISSING}")

    assert ok.status_code == 200
    assert ok.json()["name"] == "Zé"
    assert ok.json()["role"]["id"] == role.id
    assert member.id in [m["id"] for m in listing.json()]
    assert missing.status_code == 404
    assert missing.json()["detail"] == "Faina Member Not Found"


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_and_updates_faina_member(
    client: TestClient, db: SessionTesting
) -> None:
    faina, role, other = _faina(db), _role(db), _role(db, "Doutor", 2)
    db.commit()

    created = client.post(
        f"{API}/faina/member/",
        json={"faina_id": faina.id, "role_id": role.id, "name": "Maria"},
    )
    assert created.status_code == 201
    member_id = created.json()["id"]

    updated = client.put(f"{API}/faina/member/{member_id}", json={"role_id": other.id})

    assert updated.status_code == 200
    assert updated.json()["role"]["name"] == "Doutor"
    assert updated.json()["name"] == "Maria"


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_update_unknown_faina_member_is_404(client: TestClient) -> None:
    assert client.put(f"{API}/faina/member/{MISSING}", json={"name": "x"}).status_code == 404


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_faina_member_requires_faina_and_role(client: TestClient) -> None:
    assert client.post(f"{API}/faina/member/", json={"name": "x"}).status_code == 422


@pytest.mark.parametrize("client,status_code", WRITE_ONLY_AUTH, indirect=["client"])
def test_faina_member_writes_require_manager(client: TestClient, status_code: int) -> None:
    body = {"faina_id": 1, "role_id": 1}
    assert client.post(f"{API}/faina/member/", json=body).status_code == status_code
    assert client.put(f"{API}/faina/member/1", json=body).status_code == status_code


# ---------------------------------------------------------------------- faina


@pytest.mark.parametrize("client", [None], indirect=True)
def test_faina_listing_embeds_members(client: TestClient, db: SessionTesting) -> None:
    faina, role = _faina(db, "2024/25"), _role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id, name="Zé"))
    db.commit()

    r = client.get(f"{API}/faina/")

    assert r.status_code == 200
    entry = next(f for f in r.json() if f["id"] == faina.id)
    assert entry["mandate"] == "2024/25"
    assert [m["name"] for m in entry["members"]] == ["Zé"]


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_and_updates_faina(client: TestClient) -> None:
    created = client.post(f"{API}/faina/", json={"mandate": "2023/24"})
    assert created.status_code == 201
    faina_id = created.json()["id"]

    updated = client.put(f"{API}/faina/{faina_id}", json={"mandate": "2022/23"})

    assert updated.status_code == 200
    assert updated.json()["mandate"] == "2022/23"


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
@pytest.mark.parametrize("mandate", ["2023-24", "23/24", "abc", ""])
def test_faina_rejects_malformed_mandate(client: TestClient, mandate: str) -> None:
    assert client.post(f"{API}/faina/", json={"mandate": mandate}).status_code == 422


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_update_unknown_faina_is_404(client: TestClient) -> None:
    assert client.put(f"{API}/faina/{MISSING}", json={"mandate": "2020/21"}).status_code == 404


@pytest.mark.parametrize("client,status_code", WRITE_ONLY_AUTH, indirect=["client"])
def test_faina_writes_require_manager(client: TestClient, status_code: int) -> None:
    assert client.post(f"{API}/faina/", json={"mandate": "2020/21"}).status_code == status_code
    assert client.put(f"{API}/faina/1", json={"mandate": "2020/21"}).status_code == status_code


# --------------------------------------------------------------------- senior


def _senior(db: SessionTesting, year: int = 2025, course: str = "LEI") -> Senior:
    senior = Senior(year=year, course=course)
    db.add(senior)
    db.flush()
    return senior


@pytest.mark.parametrize("client", [None], indirect=True)
def test_seniors_listing_embeds_students(client: TestClient, db: SessionTesting) -> None:
    senior, user = _senior(db), _user(db)
    db.add(SeniorStudent(senior_id=senior.id, user_id=user.id, quote="Ad astra"))
    db.commit()

    r = client.get(f"{API}/senior/")

    assert r.status_code == 200
    entry = next(s for s in r.json() if s["id"] == senior.id)
    assert (entry["year"], entry["course"]) == (2025, "LEI")
    assert entry["students"][0]["quote"] == "Ad astra"
    assert entry["students"][0]["user"]["id"] == user.id


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_and_updates_senior(client: TestClient) -> None:
    created = client.post(f"{API}/senior/", json={"year": 2024, "course": "LEI"})
    assert created.status_code == 201
    senior_id = created.json()["id"]

    updated = client.put(f"{API}/senior/{senior_id}", json={"year": 2023})

    assert updated.status_code == 200
    assert (updated.json()["year"], updated.json()["course"]) == (2023, "LEI")


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_senior_course_is_length_limited(client: TestClient) -> None:
    r = client.post(f"{API}/senior/", json={"year": 2024, "course": "TOOLONG"})

    assert r.status_code == 422


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_update_unknown_senior_is_404(client: TestClient) -> None:
    assert client.put(f"{API}/senior/{MISSING}", json={"year": 1}).status_code == 404


@pytest.mark.parametrize("client,status_code", WRITE_ONLY_AUTH, indirect=["client"])
def test_senior_writes_require_manager(client: TestClient, status_code: int) -> None:
    assert client.post(f"{API}/senior/", json={"year": 1, "course": "A"}).status_code == status_code
    assert client.put(f"{API}/senior/1", json={"year": 1}).status_code == status_code


# ------------------------------------------------------------- senior student


@pytest.mark.parametrize("client", [None], indirect=True)
def test_senior_students_are_public(client: TestClient, db: SessionTesting) -> None:
    senior, user = _senior(db, 2021, "LEI"), _user(db)
    db.add(SeniorStudent(senior_id=senior.id, user_id=user.id, quote="q"))
    db.commit()

    r = client.get(f"{API}/senior/student/")

    assert r.status_code == 200
    assert [s["senior_id"] for s in r.json()] == [senior.id]


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_and_updates_senior_student(
    client: TestClient, db: SessionTesting
) -> None:
    senior, user = _senior(db, 2020, "LEI"), _user(db)
    db.commit()

    created = client.post(
        f"{API}/senior/student/",
        json={"senior_id": senior.id, "user_id": user.id, "image": "/a.png", "quote": "hi"},
    )
    assert created.status_code == 201

    updated = client.put(
        f"{API}/senior/student/{senior.id}/{user.id}", json={"quote": "bye"}
    )

    assert updated.status_code == 200
    assert updated.json()["quote"] == "bye"


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_senior_student_requires_image_and_limits_quote(client: TestClient) -> None:
    no_image = client.post(f"{API}/senior/student/", json={"senior_id": 1, "user_id": 1})
    long_quote = client.post(
        f"{API}/senior/student/",
        json={"senior_id": 1, "user_id": 1, "image": "/a", "quote": "x" * 281},
    )

    assert no_image.status_code == 422
    assert long_quote.status_code == 422


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_update_unknown_senior_student_is_404(client: TestClient) -> None:
    r = client.put(f"{API}/senior/student/{MISSING}/{MISSING}", json={"quote": "x"})

    assert r.status_code == 404
    assert r.json()["detail"] == "Senior student not found"


@pytest.mark.parametrize("client,status_code", WRITE_ONLY_AUTH, indirect=["client"])
def test_senior_student_writes_require_manager(client: TestClient, status_code: int) -> None:
    body = {"senior_id": 1, "user_id": 1, "image": "/a"}
    assert client.post(f"{API}/senior/student/", json=body).status_code == status_code
    assert client.put(f"{API}/senior/student/1/1", json={"quote": "x"}).status_code == status_code


# ---------------------------------------------------------------- team member


def _section(db: SessionTesting) -> TeamSection:
    mandate = TeamMandate(mandate="2031/32")
    db.add(mandate)
    db.flush()
    section = TeamSection(mandate_id=mandate.id, name="Coord", weight=0)
    db.add(section)
    db.flush()
    return section


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_manager_creates_updates_and_deletes_team_member(
    client: TestClient, db: SessionTesting
) -> None:
    section = _section(db)
    db.commit()

    created = client.post(
        f"{API}/team/member/",
        json={"section_id": section.id, "name": "Ana", "role": "Coord", "weight": 2},
    )
    assert created.status_code == 201
    member_id = created.json()["id"]
    assert created.json()["weight"] == 2

    updated = client.put(f"{API}/team/member/{member_id}", json={"role": "Vice"})
    assert updated.status_code == 200
    assert (updated.json()["role"], updated.json()["name"]) == ("Vice", "Ana")

    deleted = client.delete(f"{API}/team/member/{member_id}")
    assert deleted.status_code == 204
    assert deleted.content == b""
    assert client.delete(f"{API}/team/member/{member_id}").status_code == 404


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_team_member_unknown_id_is_404(client: TestClient) -> None:
    assert client.put(f"{API}/team/member/{MISSING}", json={"role": "x"}).status_code == 404
    assert client.delete(f"{API}/team/member/{MISSING}").status_code == 404


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_team_member_update_forbids_unknown_fields(
    client: TestClient, db: SessionTesting
) -> None:
    section = _section(db)
    member = TeamMember(section_id=section.id, name="x", role="y")
    db.add(member)
    db.commit()

    r = client.put(f"{API}/team/member/{member.id}", json={"nonsense": 1})

    assert r.status_code == 422


@pytest.mark.parametrize("client", [MANAGER], indirect=True)
def test_team_member_create_requires_name_role_section(client: TestClient) -> None:
    assert client.post(f"{API}/team/member/", json={"name": "x"}).status_code == 422


@pytest.mark.parametrize("client,status_code", WRITE_ONLY_AUTH, indirect=["client"])
def test_team_member_writes_require_manager(client: TestClient, status_code: int) -> None:
    body = {"section_id": 1, "name": "a", "role": "b"}
    assert client.post(f"{API}/team/member/", json=body).status_code == status_code
    assert client.put(f"{API}/team/member/1", json={"role": "b"}).status_code == status_code
    assert client.delete(f"{API}/team/member/1").status_code == status_code
