import os

from logging.config import fileConfig

from sqlalchemy.schema import CreateSchema
from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context

from app.db.base import Base
from app.core.config import settings

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

section = config.config_ini_section
config.set_section_option(
    section, "POSTGRES_USER", os.environ.get("POSTGRES_USER", "postgres")
)
config.set_section_option(
    section, "POSTGRES_PASSWORD", os.environ.get("POSTGRES_PASSWORD", "postgres")
)
config.set_section_option(
    section, "POSTGRES_SERVER", os.environ.get("POSTGRES_SERVER", "localhost")
)
config.set_section_option(
    section, "POSTGRES_PORT", os.environ.get("POSTGRES_PORT", "5432")
)

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None and config.attributes.get(
    "configure_logger", True
):
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
# from myapp import mymodel
# target_metadata = mymodel.Base.metadata
target_metadata = Base.metadata

# other values from the config, defined by the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        version_table_schema=settings.SCHEMA_NAME,
    )

    with context.begin_transaction():
        context.run_migrations()


def include_name(name, type_, parent_names):
    if type_ == "schema":
        return name in [settings.SCHEMA_NAME]
    else:
        return True


def run_migrations_online() -> None:
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connection = config.attributes.get("connection", None)
    connection_provided = connection is not None

    try:
        if not connection_provided:
            # only create Engine if we don't have a Connection
            # from the outside
            connectable = engine_from_config(
                config.get_section(config.config_ini_section, {}),
                prefix="sqlalchemy.",
                poolclass=pool.NullPool,
            )

            connection = connectable.connect()
            connection.__enter__()

        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            include_schemas=True,
            include_name=include_name,
            version_table_schema=settings.SCHEMA_NAME,
        )

        connection.execute(CreateSchema(settings.SCHEMA_NAME, if_not_exists=True))

        with context.begin_transaction():
            context.run_migrations()

    finally:
        if not connection_provided:
            connection.__exit__(None, None, None)


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
