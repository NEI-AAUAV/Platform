from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy.sql import text
from sqlalchemy import event

from app.core.config import settings
from .base import Base
from .session import engine

# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db() -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables with Base.metadata.create_all(bind=engine)

    with engine.connect() as conn:
        if not engine.dialect.has_schema(conn, schema=settings.SCHEMA_NAME):
            event.listen(
                Base.metadata,
                "before_create",
                CreateSchema(settings.SCHEMA_NAME),
                insert=True,
            )

            Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
            Base.metadata.create_all(bind=engine, checkfirst=True)

            if not settings.PRODUCTION:
                # Create superuser for development with username 'dev' and password 'dev'
                stmts = text(
                    """
                INSERT INTO nei."user" (id, name, surname, updated_at, created_at, scopes, hashed_password, birthday) VALUES
                (0, 'Dev', 'Test', '2023-01-01T00:00:00', '2023-01-01T00:00:00', ARRAY['ADMIN']::nei.scope_enum[], '$argon2id$v=19$m=65536,t=3,p=4$IqRUqvW+N8a4d865F4KQ0g$orC7ZOBIJG3t0XOhzmKNaewh7OwgfWuoj2SGEb4OcHQ', '2023-01-01');
                INSERT INTO nei."user_email" (user_id, email, active) VALUES
                (0, 'dev@dev.dev', TRUE);
                """
                )
                conn.execute(stmts)
                conn.commit()

            # Populate Database
            file = open("./app/db/backup-0001.sql")
            stmts = text(file.read())
            conn.execute(stmts)
            conn.commit()
