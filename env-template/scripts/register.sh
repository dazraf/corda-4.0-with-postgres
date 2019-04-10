#!/usr/bin/env bash

java -jar ../corda.jar  --initial-registration --network-root-truststore ../truststore.jks  --network-root-truststore-password trustpass
