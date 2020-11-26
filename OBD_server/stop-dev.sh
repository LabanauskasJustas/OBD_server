#!/bin/bash

docker-compose stop
if [[ "$OSTYPE" == "darwin"* ]]; then
docker-sync stop
fi
