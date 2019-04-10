# What this tests

* Corda 4.0 open source
* Postgres database 9.6
* Postgres drivers for both [postgresql-42.1.4.jar](libs/postgresql-42.1.4.jar) and [postgresql-42.2.5.jar](libs/postgresql-42.2.5.jar)
* "production" mode with a network map

# What do I need

* [docker-compose](https://runnable.com/docker/install-docker-on-macos)
* [overmind](https://github.com/DarthSim/overmind)

# How to build and run

```bash
cd <project root>
./start.sh
```

# Known issues

Version of NMS being used sometimes fails to start owing to a bug in a legacy version of vertx.