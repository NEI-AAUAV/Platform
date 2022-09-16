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

The API will be available at [localhost:8000/api](http://localhost:8000/api).



### Commom errors

It is probable that your PHP does not have the extension for `pdo_mysql` activated by default. If when accessing the API it returns a 500 http status code with the payload "Ocorreu um erro na conexão à base de dados", it is probably the case.

To solve it, go to `http://localhost:8000/api/` and search the table for **Configuration File (php.ini) Path ** field. Go to that folder, and open the `php.ini` file with admin permissions. Search for the line that has `extension=pdo_mysql` and remove the `;` that is in the beginning of it.

Restart the server and the problem should be fixed.



## Documentation

The API endpoints were listed and documented with Postman, an application that allows interactive API testing. It can be downloaded at https://www.getpostman.com.

After downloading it, click the button below to open the NEI API collection.

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/7af49970eb4e5516c575)

Sometimes, uploading large image files on form-data with Postman resulted in "There was an error parsing the body". This is a Postman issue, that is described [here](https://github.com/tiangolo/fastapi/issues/2401#issuecomment-735454025). A solution could be to use similar applications to Postman, like [Insomnia]( https://insomnia.rest/).
