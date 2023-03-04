# NEI Web-App

It is important to keep the number of dependencies as few as possible. If there is one that makes the job easier and that is foreseeable to be used in the future, then it is recommended.


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

On the service's root directory, build the image that will be used to create the service container. The flag `--no-cache` can be useful in some situations that require to not use cache when building the image.
```
docker build . -t web_nei [--no-cache]
```

Create the NEI WebApp service.
```
docker run -it -v ${PWD}:/web_nei -v /web_nei/node_modules --network host --name web_nei web_nei
```

With this latter step, everything is setup. To restart the service afterwards, simply run `docker start -i web_nei` (the -i flag runs the container in interactive mode).
