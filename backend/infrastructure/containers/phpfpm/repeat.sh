#!/bin/sh

while [ 1 == 1 ]
do
  echo "Running cron"
  php /var/www/app/artisan schedule:run
  sleep 60
done
