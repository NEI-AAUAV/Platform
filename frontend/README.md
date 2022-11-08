# Web-App Service

## Local Installation

Download the node setup. Install `curl` with `sudo apt-get install curl` if needed.
```
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
```

After this, the command `node -v` should return the version 16.
```
sudo apt-get install nodejs
```

Install `yarn`:
```
sudo npm install --global yarn
```

On the service's root directory, install the dependencies with this command. All dependencies will be saved in the `node_modules` folder, which will be created.
```
yarn install
```

Finally, to start the service run:
```
yarn start
```

## Docker Installation

Create the container for the PostgreSQL database.
```
docker run -d -p 0.0.0.0:5432:5432 -e POSTGRES_PASSWORD="postgres" --name pg_db postgres
```

On the service's root directory, build the image that will be used to create the service container. The flag `--no-cache` can be useful in some situations that require to not use cache when building the image.
```
docker build . -f Dockerfile.dev -t nei_api [--no-cache]
```

Create the NEI-API service.
```
docker run -it -v ${PWD}:/web_app -v /web_app/node_modules --network host --name nei_api nei_api
```

With this latter step, everything is setup. To restart the service afterwards, simply run `docker start pg_db` and `docker start -i nei_api` (the -i flag runs the container in interactive mode).
