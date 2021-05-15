#!/bin/sh

#./kubernetes/artisan.sh migrate:refresh --force
#./kubernetes/artisan.sh --force migrate:refresh
#./kubernetes/artisan.sh --force db:seed
#./kubernetes/artisan.sh passport:install
./kubernetes/artisan.sh key:generate --force
