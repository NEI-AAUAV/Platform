from sqlalchemy.sql import text
from alembic import command, config

from .session import engine
from app.utils import ROOT_DIR
from app.core.config import settings

# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28
from .base import Base

# Update me after finishing writing a migration
last_known_good_revision = "caaa223a3654"


def init_db() -> None:
    if not settings.PRODUCTION:
        with engine.connect() as conn:
            cfg = config.Config(f"{ROOT_DIR}/alembic.ini")
            cfg.attributes["connection"] = conn
            cfg.attributes["configure_logger"] = False
            command.upgrade(cfg, last_known_good_revision)

            # Create superuser for development with username 'dev' and password 'dev'
            stmts = text(
                """
                INSERT INTO nei."user" (id, name, surname, updated_at, created_at, scopes, hashed_password, birthday) VALUES
                (0, 'Dev', 'Test', '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY['admin']::text[], '$argon2id$v=19$m=65536,t=3,p=4$IqRUqvW+N8a4d865F4KQ0g$orC7ZOBIJG3t0XOhzmKNaewh7OwgfWuoj2SGEb4OcHQ', '2023-01-01')
                ON CONFLICT DO NOTHING;
                INSERT INTO nei."user_email" (user_id, active, email) VALUES
                (0, TRUE, 'dev@dev.dev')
                ON CONFLICT DO NOTHING;
                """
            )
            conn.execute(stmts)
            conn.commit()
