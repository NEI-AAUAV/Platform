from logging.config import fileConfig
from alembic import context
from sqlalchemy import engine_from_config, pool, text
from app.core.config import settings
from app.models.base import Base

config = context.config
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata

def _include_object(obj, name, type_, reflected, compare_to):
    if hasattr(obj, "schema") and obj.schema and obj.schema != settings.SCHEMA_NAME:
        return False
    return True

def run_migrations_offline():
    context.configure(
        url=str(settings.POSTGRES_URI),
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
        compare_server_default=True,
        include_schemas=True,
        version_table_schema=settings.SCHEMA_NAME,
        include_object=_include_object,
    )
    with context.begin_transaction():
        context.execute(f"SET search_path TO {settings.SCHEMA_NAME}")
        context.run_migrations()

def run_migrations_online():
    configuration = config.get_section(config.config_ini_section) or {}
    configuration["sqlalchemy.url"] = str(settings.POSTGRES_URI)
    connectable = engine_from_config(
        configuration, prefix="sqlalchemy.", poolclass=pool.NullPool
    )
    with connectable.connect() as connection:
        connection.execute(f"SET search_path TO {settings.SCHEMA_NAME}")
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
            include_schemas=True,
            version_table_schema=settings.SCHEMA_NAME,
            include_object=_include_object,
        )
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()