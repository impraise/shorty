Shorty Challenge - João Serra
================

This is my solution to the Shorty Challenge.

It uses Grape framework for the API and MongoDB as a datastore.

I used docker and docker compose in the project to make it possible to run out of the box in any machine, provided it has docker and docker-compose installed.

If docker is not installed in the machine follow these steps:
(you may need root permissions)

install docker:
`apt-get install docker`

install docker-compose:
```
curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

If you run in any troubles, please refer to docker documentation for help:
https://docs.docker.com/engine/installation/linux/ubuntu/
https://docs.docker.com/compose/install/

After installing docker, you are all set and can start having some fun!

To run the project tests, use the following command:
`docker-compose build && docker-compose run tests`

To run the project in development mode:
`docker-compose up --build dev`

This will start the service in development mode in port 9292

To run the project in production mode:
`docker-compose up --build production`

This will start the service in production mode in port 4000
