FROM flaxandteal/docker-laravel-phpfpm:7.4.3-alpine

COPY ./infrastructure/containers/phpfpm/php.ini /usr/local/etc/php

COPY . /var/www/app

RUN mkdir -p /var/www/app/storage; (chown -R :www-data /var/www/app/storage && chmod -R g+rwX /var/www/app/storage)
