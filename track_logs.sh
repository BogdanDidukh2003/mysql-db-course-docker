#!/bin/bash

echo "----------mysqldb----------" >> /tmp/spring-boot-app/log
docker container logs mysqldb >> /tmp/spring-boot-app/log

cat /tmp/spring-boot-app/log

echo "----------spring-boot-app----------"
docker container logs -f spring-boot-app

