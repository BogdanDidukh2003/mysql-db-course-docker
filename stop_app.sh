#!/bin/bash

echo "[INFO] Cleaning..."

rm -r /tmp/spring-boot-app/
mkdir /tmp/spring-boot-app/
touch /tmp/spring-boot-app/log
rm -rf ./temp_for_docker

docker container stop spring-boot-app
docker container stop mysqldb
sleep 10;

docker container rm -f mysqldb spring-boot-app
docker image rm -f spring-boot
docker network rm spring-boot-mysql

echo "Done"

