#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

cp $SCRIPT_DIR/config/secrets/laravel.env.local $SCRIPT_DIR/config/secrets/laravel.env
cp $SCRIPT_DIR/config/secrets/redis.env.local $SCRIPT_DIR/config/secrets/redis.env
sed "s#SCRIPT_DIR#${SCRIPT_DIR}#g" $SCRIPT_DIR/docker-compose.yml.tpl > $SCRIPT_DIR/docker-compose.yml
cp $SCRIPT_DIR/dartisan .
cp $SCRIPT_DIR/docker-compose.yml docker-compose.yml

#Chmod command so the container can write and read to the host file system that is mounted in to the container
chmod 777 ../{,/storage{,/framework{,/views,/cache}}}
