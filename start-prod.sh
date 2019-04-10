#!/usr/bin/env bash

set -e
CORDA_VERSION="4.0"

# ensure everything is dead
killall -9 java
docker-compose down || true

## build
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
  cp -R ../env-templates/prod/* .
  cp ./scripts/* ./notary
  cp ./scripts/* ./partya
  cp ./scripts/* ./partyb

  # get the truststore
  echo "retrieving network truststore"
  wget http://localhost:8080/network-map/truststore -O truststore.jks

  echo "retrieving corda.jar for version ${CORDA_VERSION}"
  curl -L https://dl.bintray.com/r3/corda/net/corda/corda/${CORDA_VERSION}/corda-${CORDA_VERSION}.jar --output ./corda.jar

  # register notary and set it up as a whitelisted notary in the network-parameters
  pushd notary
    echo "registering notary"
    ./register.sh
    NODE_INFO=$(ls nodeInfo*)
    echo "authenticating with NMS"
    TOKEN=`curl -X POST "http://localhost:8080//admin/api/login" -H  "accept: text/plain" -H  "Content-Type: application/json" -d "{  \"user\": \"sa\",  \"password\": \"admin\"}"`
    echo "token received: ${TOKEN}"
    curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "accept: text/plain" -H "Content-Type: application/octet-stream" --data-binary @${NODE_INFO} http://localhost:8080/admin/api/notaries/nonValidating
  popd # notary

  pushd partya
    echo "registering partya"
    ./register.sh
  popd # partya

  pushd partyb
    echo "registering partyb"
    ./register.sh
  popd # partyb

echo "starting up all nodes"

overmind start
popd # tmp-env