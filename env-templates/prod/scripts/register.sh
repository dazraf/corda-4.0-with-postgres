#!/usr/bin/env bash

mkdir cordapps
cp ../../contracts/build/libs/*.jar ./cordapps/
cp ../../workflows/build/libs/*.jar ./cordapps/
java -jar ../corda.jar  initial-registration --network-root-truststore ../truststore.jks  --network-root-truststore-password trustpass
