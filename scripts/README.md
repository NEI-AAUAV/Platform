# Backend support scripts

## `backup-db.sh`

This script is responsible for backing up the database running inside a docker
container, the container name and other options can be changed in the preamble
of the script.

The backups can be encrypted with a gpg key that must be specified in the variable 
`ENCRYPTION_KEY`. Run the command `gpg --list-keys` to view your keys and copy the key id 
(e.g. DF022A703CxxxxxxxxxxxxxxxxxxxxCF469074D3) to the variable.

```
Usage: script [--output OUTPUT] [--compress] [--encrypt] [--help] [<container>]

Options:
  -o OUTPUT, --output OUTPUT  Save the backup to the provided path [default: /dev/stdin].
  --compress                  Apply zstd compression to the backup [default: off].
  --encrypt                   Encrypt the backup before applying it [default: off].
  -h, --help                  Prints help.
```

To install the script in the production machine, first the options must be
configured and afterwards the script must be copied to `/etc/cron.weekly` for
weekly backups.

```bash
sudo cp backup-db.sh /etc/cron.weekly
```

## `restore-db.sh`

This script is responsible for restoring the database running inside a docker
container from a backup, the function expects the container name to be passed
trough the command line, the backup location (defaults to stdin) and other
options can be changed trough command line arguments.

```
Usage: script [--input INPUT] [--decompress] [--decrypt] [<container>]

Options:
  -i INPUT, --input INPUT  Read the backup from the provided path [default: /dev/stdin].
  --decompress             Decompress the backup before applying it [default: off].
  --decrypt                Decrypt the backup before applying it [default: off].
```
