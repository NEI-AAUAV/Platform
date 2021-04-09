# NEI API



## Run locally 

To run the API locally, you must have installed the latest version of PHP. To ensure you have it, run the command below.

```bash
$ php -v
# Must return PHP 8.X.X (...)
```

After installing it, just go the the repository root folder (where api, docs and src folders are) and run the command below.

```bash
php -S localhost:8000
```

The API will be available at `localhost:8000/api`.



### Commom errors

It is probable that your PHP does not have the extension for `pdo_mysql` activated by default. If when accessing the API it returns a 500 http status code with the payload "Ocorreu um erro na conexão à base de dados", it is probably the case.

To solve it, go to `http://localhost:8000/api/` and search the table for **Configuration File (php.ini) Path ** field. Go to that folder, and open the `php.ini` file with admin permissions. Search for the line that has `extension=pdo_mysql` and remove the `;` that is in the beginning of it.

Restart the server and the problem should be fixed.