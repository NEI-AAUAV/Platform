from logging.config import fileConfig

from sqlalchemy.schema import CreateSchema
import sqlalchemy as sa
from sqlalchemy import engine_from_config
from sqlalchemy import pool

from alembic import context

from app.db.base import Base
from app.core.config import settings

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
# Arbitrary but fixed: only this migration runner uses it.
_LOCK_KEY = 4242424242

config = context.config

# The app and the migrations must resolve to the same database. settings is
# the single source; a caller that supplies its own url (the test suite) wins.
if not config.get_main_option("sqlalchemy.url", None):
    # set_main_option goes through ConfigParser, so a percent-encoded
    # character in the password has to be escaped or it reads as interpolation.
    config.set_main_option("sqlalchemy.url", settings.POSTGRES_URI.replace("%", "%%"))

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
            compare_type=True,
            version_table_schema=settings.SCHEMA_NAME,
        )

        with context.begin_transaction():
            # Alembic reads the version table with a plain SELECT, so two
            # deploys can both plan the same chain; the second then dies on a
            # duplicate-key error from CREATE SCHEMA IF NOT EXISTS, which is
            # not race-safe across concurrent transactions. The advisory lock
            # is transaction-scoped: the second run waits, re-reads, no-ops.
            connection.execute(sa.text("SELECT pg_advisory_xact_lock(:key)"), {"key": _LOCK_KEY})
            # Never queue behind a long read from the old container, which is
            # still serving while this runs. Migrations themselves may be slow,
            # so no statement timeout.
            connection.execute(sa.text("SET LOCAL lock_timeout = '5s'"))
            connection.execute(sa.text("SET LOCAL statement_timeout = '0'"))

            connection.execute(CreateSchema(settings.SCHEMA_NAME, if_not_exists=True))
            context.run_migrations()

    finally:
        if not connection_provided and connection is not None:
            connection.__exit__(None, None, None)


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
