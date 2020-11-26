#!/bin/bash

docker-compose build

if [[ "$OSTYPE" == "darwin"* ]]; then
  docker volume create --name=bigcake
  docker-compose -f docker-compose.yml -f docker-compose.sync.yml up -d
  docker-sync start
else
  docker-compose up -d
fi
docker-compose exec php bash
