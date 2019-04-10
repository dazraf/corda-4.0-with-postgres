#!/usr/bin/env bash

set -e

# ensure everything is dead
killall -9 java
docker-compose down || true

# build
./gradlew clean deployNodes

# start dbs and network services
docker-compose up -d

echo "waiting for network-map"
until $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q 200) ; do
  printf '.'
  sleep 1
done


# prepare the environment
mkdir -p tmp-env
rm -rf tmp-env/*

pushd tmp-env
  cp -R ../env-template/* .
  cp ./scripts/* ./notary
  cp ./scripts/* ./partya
  cp ./scripts/* ./partyb

  # get the truststore
  wget http://localhost:8080/network-map/truststore -O truststore.jks
  cp  ../build/nodes/Notary/corda.jar .

  # register notary and set it up as a whitelisted notary in the network-parameters
  pushd notary
    ./register.sh
    NODE_INFO=$(ls nodeInfo*)
    echo "authenticating with NMS"
    TOKEN=`curl -X POST "http://localhost:8080//admin/api/login" -H  "accept: text/plain" -H  "Content-Type: application/json" -d "{  \"user\": \"sa\",  \"password\": \"admin\"}"`
    echo "token received: ${TOKEN}"
    curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "accept: text/plain" -H "Content-Type: application/octet-stream" --data-binary @${NODE_INFO} http://localhost:8080/admin/api/notaries/nonValidating
  popd # notary

  pushd partya
    ./register.sh
  popd # partya

  pushd partyb
    ./register.sh
  popd # partyb

overmind start
popd # tmp-env