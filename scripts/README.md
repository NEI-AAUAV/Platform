# Backend support scripts

## `backup-db.sh`

This script is responsible for backing up the database running inside a docker
container, the container name and other options can be changed in the preamble
of the script.

To install the script in the production machine, first the options must be
configured and afterwards the script must be copied to `/etc/cron.weekly` for
weekly backups.

```bash
sudo cp backup-db.sh /etc/cron.weekly
```

## `restore-db.sh`

This script is responsible for restoring the database running inside a docker
container from a backup, the funtion expects the container name to be passed
trough the command line, the backup location (defaults to stdin) and other
options can be changed trough command line arguments.

```
Restores a database backup for the NEI database
Usage: restore-db.sh [-i|--input <arg>] [--(no-)decompress] [--(no-)decrypt] [-h|--help] <container>
	<container>: The name of the docker container with the database
	-i, --input: Read the backup from the provided path (default: '/dev/stdin')
	--decompress, --no-decompress: Decompress the backup before applying it (off by default)
	--decrypt, --no-decrypt: Decrypt the backup before applying it (off by default)
	-h, --help: Prints help
```
