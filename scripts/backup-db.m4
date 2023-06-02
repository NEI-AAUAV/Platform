#!/usr/bin/env bash
set -e

# m4_ignore(

# Built with argbash (https://github.com/matejak/argbash) for argument parsing.
#
# Use the following command to generate the script:
#   argbash backup-db.m4 -o backup-db.sh

echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11
# )
# ARG_POSITIONAL_SINGLE([container],[The name of the docker container with the database],[platform-db_pg-1])
# ARG_OPTIONAL_SINGLE([output],[o],[Save the backup to the provided path],[backup-$(date "+%Y%m%d%H%M%S").sql])
# ARG_OPTIONAL_BOOLEAN([compress],[],[Apply zstd compression to the backup])
# ARG_OPTIONAL_BOOLEAN([encrypt],[],[Encrypt the backup before applying it])
# ARG_DEFAULTS_POS
# ARG_HELP([Dumps the NEI database to a backup])
# ARGBASH_GO

# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

# Allows specifying a gpg recipient to encrypt the backup to
#
# The recipient's public key must be added to the root's keyring
ENCRYPT_RECIPIENT=""
# The path of the file to store the backup
#
# By default it backups to the current directory
BACKUP_NAME="backup-$(date "+%Y%m%d%H%M%S".sql)"

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_USER:-postgres}"
SCHEMA_NAME="${SCHEMA_NAME:-nei}"

# Command to execute the backup, the backup is written to stdout
backup() {
    # To execute the backup `pg_dump` is called from inside the container
    docker exec -i $_arg_container pg_dump -U $POSTGRES_USER -d $POSTGRES_DB -n $SCHEMA_NAME \
    --column-inserts --rows-per-insert=1000
}

# Command to encrypt stdin and write the result to stdout
encrypt() {
    # Calls gpg with a specific recipient (passed by the user), the recipient's
    # publick key must be stored in the keyring beforehand
    gpg --encrypt --recipient "$ENCRYPT_RECIPIENT"
}

# Create the backups directory if it doesn't exist
mkdir -p backups

# Write the name of the file where the backup will be written to
echo backups/"$BACKUP_NAME"

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
( [ "$_arg_compress" = "off" ] && cat || zstd ) |
# Encrypt the backup with gpg if the user requested encryption
# Pipe the backup to the file specified by the user or a default file
( [ "$_arg_encrypt" = "off" ] && cat || encrypt ) > backups/"$BACKUP_NAME"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^


# vi: ft=bash
# ] <-- needed because of Argbash
