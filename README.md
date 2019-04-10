# What this tests

* Corda 4.0 open source
* Postgres database 9.6
* "production" mode with a network map

# What do I need

* docker-compose
* overmind

# How to build and run

```bash
cd <project root>
./start.sh
```

# Known issues

Version of NMS being used sometimes fails to start owing to a bug in a legacy version of vertx.