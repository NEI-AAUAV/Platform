#!/usr/bin/env bash
set -e

# Backups the NEI database optionally compressing and/or encrypting it

# START OPTIONS

# The name of the container
CONTAINER="website_pg_db_1"
# Wether or not to apply zstd compression to the backup
#
# Must be one of "one" or "off"
COMPRESS="off"
# Allows specifying a gpg recipient to encrypt the backup to
#
# The recipient's public key must be added to the root's keyring
ENCRYPT_RECIPIENT=""
# The path of the file to store the backup
#
# By default it backups to the current directory
BACKUP_NAME="backup.sql"

POSTGRES_USER="postgres"
POSTGRES_DB="postgres"
POSTGRES_SCHEMA="aauav_nei"

# END OPTIONS

# Command to execute the backup, the backup is written to stdout
backup() {
    # To execute the backup `pg_dump` is called from inside the container
    docker exec pg_dump -U $POSTGRES_USER -d $POSTGRES_DB -n $POSTGRES_SCHEMA
}

# Command to encrypt stdin and write the result to stdout
encrypt() {
    # Calls gpg with a specific recipient (passed by the user), the recipient's
    # publick key must be stored in the keyring beforehand
    gpg --encrypt --recipient "$ENCRYPT_RECIPIENT"
}

# Write the name of the file where the backup will be written to
echo "$BACKUP_NAME"

# Extract the backup from the docker container and pass it trough a pipeline
# to allow multiple transformations online as requested by the user.
#
# Each step in the pipeline is defined as:
#   ( [ not condition ] && cat || command )
#
# This sequence works because of short-circuiting, if the condition is true, cat
# will be executed which returns a zero exit code which evaluates to true
# causing the `||` to short-circuit. If the condition is false the `&&`
# short-circuits and `cat` isn't executed.
#
# The `condition` is negated because otherwise the branches would be inverted and
# this could cause problems in case `command` returns a non-zero exit code,
# because this would execute `cat` afterwards.
# Source: https://unix.stackexchange.com/questions/38310/conditional-pipeline
backup |
# Compress the backup with zstd compression if the user requested compression
( [ "$COMPRESS" = "off" ] && cat || zstd ) |
# Encrypt the backup with gpg if the user requested encryption
# Pipe the backup to the file specified by the user or a default file
( [ -z "$ENCRYPT_RECIPIENT" ] && cat || encrypt ) > "$BACKUP_NAME"

# vi: ft=bash
