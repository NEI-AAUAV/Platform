## PostgreSQL docker commands

Enter inside the docker container using this command. Make sure the container exists and is running.
```
docker exec -it pg bash
```

After entering the container, run this to connect to the database:
```
psql -U postgres
```

Practical psql commands:

- `\dn`             &emsp;List all schemas
- `\dt`             &emsp;List tables
- `\dt aauav_nei.*` &emsp;List tables under schema 'aauav_nei'
- `\? `             &emsp;Show help

Check that there is data inside any table:
```
SELECT * FROM aauav_nei.tacaua_game;
```

To work in a specific schema, run the following comand, which is an alias for `SET search_path TO 'aauav_nei';`.
The next commands will be related to the specified schema, `\dt` will be the same as `\dt aauav_nei.*` and there is no need to use the schema name when referring to tables on queries: `SELECT * FROM tacaua_game`.
```
SET SCHEMA 'aauav_nei';
```

To undo the last command, run:
```
RESET search_path;
```