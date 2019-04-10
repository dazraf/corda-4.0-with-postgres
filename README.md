# What this tests

* Corda 4.0 open source
* Postgres database 9.6
* Postgres drivers for both [postgresql-42.1.4.jar](libs/postgresql-42.1.4.jar) and [postgresql-42.2.5.jar](libs/postgresql-42.2.5.jar)
* "production" mode with a network map
* "dev" mode using network-bootstrapper

# What do I need

* [docker-compose](https://runnable.com/docker/install-docker-on-macos)
* [overmind](https://github.com/DarthSim/overmind)

# How to build and run

## 'Prod' mode

This creates a full environment locally. Includes [Cordite network-map service](https://gitlab.com/cordite/network-map-service).

```bash
cd <project root>
./start.sh
```

## 'Dev' mode

This creates a set of nodes locally using the network bootstrapper.

```[TBD]```

<TBD>

# Known issues

Version of NMS being used sometimes fails to start owing to a bug in a legacy version of vertx.