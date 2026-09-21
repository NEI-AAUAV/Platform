from fastapi import Depends, FastAPI
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.api import deps


class _CommitFailureSession:
    def __init__(self) -> None:
        self.mutated = False
        self.rolled_back = False
        self.closed = False

    def commit(self) -> None:
        raise RuntimeError("simulated commit failure")

    def rollback(self) -> None:
        self.rolled_back = True

    def close(self) -> None:
        self.closed = True


def test_commit_failure_cannot_return_success(monkeypatch) -> None:
    session = _CommitFailureSession()
    monkeypatch.setattr(deps, "SessionLocal", lambda: session)
    app = FastAPI()

    @app.post("/write")
    def write(
        db: Session = Depends(deps.get_db, scope="function"),
    ) -> dict[str, bool]:
        session.mutated = True
        return {"ok": True}

    with TestClient(app, raise_server_exceptions=False) as client:
        response = client.post("/write")

    assert response.status_code == 500
    assert session.mutated is True
    assert session.rolled_back is True
    assert session.closed is True
