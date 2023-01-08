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

The schema `aauav_nei` and the tables inside it will only exist after running the API (it creates the tables automatically on startup). Thus, if `\dn` does not list `aauav_nei`, then it is probably due to that.

To check that there is data inside any table, we can run `SELECT` queries, as such:
```
SELECT * FROM aauav_nei.tacaua_game;
```

### Set a specific schema

To work in a specific schema, run the following comand, which is an alias for `SET search_path TO 'aauav_nei';`.
The next commands will be related to the specified schema, `\dt` will be the same as `\dt aauav_nei.*` and there is no need to use the schema name when referring to tables on queries: `SELECT * FROM tacaua_game`.
```
SET SCHEMA 'aauav_nei';
```

To undo the last command, run:
```
RESET search_path;
```

### Clean database

With the current setup, the default data inside the tables that is defined in `nei-api/app/db/init_db.py` is only inserted after the tables creation. Once the tables are created, the event listener will not run and, therefore, will not insert any additional data. For this reason, it may be needed to clean the database to force the table creation again. To do this, it is simpler if the schema `aauav_nei` is deleted with:

```
DROP SCHEMA aauav_nei CASCADE;
```
