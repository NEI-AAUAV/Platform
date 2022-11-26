#!/usr/bin/env bash
set -e

# m4_ignore(

# Built with argbash (https://github.com/matejak/argbash) for argument parsing.
#
# Use the following command to generate the script:
#   argbash restore-db.m4 -o restore-db.sh

echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11
# )
# ARG_OPTIONAL_SINGLE([input], i, [Read the backup from the provided path], [/dev/stdin])
# ARG_OPTIONAL_BOOLEAN([decompress], , [Decompress the backup before applying it])
# ARG_OPTIONAL_BOOLEAN([decrypt], , [Decrypt the backup before applying it])
# ARG_POSITIONAL_SINGLE([container], [The name of the docker container with the database])
# ARG_DEFAULTS_POS
# ARG_HELP([Restores a database backup for the NEI database])
# ARGBASH_GO

# [ <-- needed because of Argbash

# vvv  PLACE YOUR CODE HERE  vvv

# Command to restore the backup, expects the backup in stdin
restore() {
    # To execute the backup `psql` is piped the backup inside the container
    RESTORE_CMD="psql -U postgres"
    docker exec -i "$_arg_container" $RESTORE_CMD
}

# Command to decrypt stdin and write the result to stdout
decrypt() {
    # Simply calls gpg to decrypt, the private key must be present in the keyring
    gpg --decrypt
}

# Restores the backup to a docker container, the backup may optionally be passed
# trough a pipeline to allow multiple transformations online as requested by the user
# before restoring it.
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
#
# Decrypt the backup with gpg if the user requested it
( [ "$_arg_decrypt" = "off" ] && cat || decrypt ) < "$_arg_input" |
# Decompress the backup with zstd compression if the user requested it
( [ "$_arg_decompress" = "off" ] && cat || unzstd ) |
# Finally restore the backup
restore

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

# vi: ft=bash
