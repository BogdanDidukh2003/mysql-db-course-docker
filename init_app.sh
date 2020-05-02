#!/bin/bash

echo "[INFO] Cleaning up..."

rm -r /tmp/spring-boot-app/
mkdir /tmp/spring-boot-app/
touch /tmp/spring-boot-app/log

echo "----------cleaning----------" >> /tmp/spring-boot-app/log

rm -rf ./temp_for_docker >> /tmp/spring-boot-app/log

docker container stop spring-boot-app >> /tmp/spring-boot-app/log
docker container stop mysqldb >> /tmp/spring-boot-app/log
sleep 10;
docker container rm -f mysqldb spring-boot-app >> /tmp/spring-boot-app/log
docker image rm -f spring-boot >> /tmp/spring-boot-app/log
docker network rm spring-boot-mysql >> /tmp/spring-boot-app/log

echo "[INFO] Fetching repository..."
echo "----------git fetching----------" >> /tmp/spring-boot-app/log

mkdir ./temp_for_docker >> /tmp/spring-boot-app/log
cd ./temp_for_docker >> /tmp/spring-boot-app/log

git clone "https://github.com/shine-at-dusk/mysql-db-course.git" >> /tmp/spring-boot-app/log
cd mysql-db-course/Lab6 >> /tmp/spring-boot-app/log

echo "[INFO] Creating docker network..."
echo "----------docker network----------" >> /tmp/spring-boot-app/log

docker network create spring-boot-mysql >> /tmp/spring-boot-app/log

echo "[INFO] Creating docker volume if it does not exist..."
echo "----------docker volume----------" >> /tmp/spring-boot-app/log

docker volume create mysql-data-backup >> /tmp/spring-boot-app/log

echo "[INFO] Running mysql container..."
echo "----------mysqldb start----------" >> /tmp/spring-boot-app/log

docker container run -v mysql-data-backup:/var/lib/mysql --name mysqldb --network spring-boot-mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=shutka -d mysql:5.7 >> /tmp/spring-boot-app/log

echo "[INFO] Waiting for mysql to start properly..."
sleep 30;

echo "[INFO] Building spring-boot image..."
echo "----------spring-boot image----------" >> /tmp/spring-boot-app/log

docker image build -t spring-boot . >> /tmp/spring-boot-app/log

echo "[INFO] Running spring-boot container..."
echo "----------spring-boot-app start----------" >> /tmp/spring-boot-app/log

docker container run -p 8080:8080 --name spring-boot-app --network spring-boot-mysql -d spring-boot >> /tmp/spring-boot-app/log

rm -rf ../../../temp_for_docker/ >> /tmp/spring-boot-app/log
echo "Done"

