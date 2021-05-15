version: "2"
services:
{% if frontend %}
  frontend:
    image: node:10.9-stretch
    working_dir: /home/node/app
    environment:
      - NODE_ENV=dev
      - HOST=frontend
    volumes:
      - {{ frontend }}:/home/node/app
    ports:
      - "8080:8080"
    command: "npm run serve"
{% endif %}
  db:
    image: postgres
    volumes:
      - {{ docker }}/storage/db:/data
    environment:
      PGDATA: /data
    env_file:
      - {{ docker }}/config/laravel.env
  phpfpm:
    build:
      context: {{ buckram }}/containers/phpfpm
      dockerfile: Dockerfile.debug
    links:
      - db:db
      - redis:redis
    volumes:
      - {{ laravel }}:/data/www
      - {{ laravel }}:/var/www/app
      - {{ docker }}/storage/phpfpm/xdebug:/tmp/xdebug
    env_file:
      - {{ docker }}/config/laravel.env
      - {{ docker }}/config/redis.env
    environment:
      REDIS_HOST: "redis"
      REDIS_PORT: 6379
      APP_LOG: "stack"
      LOG_CHANNEL: "stack"
  nginx:
    image: nginx:stable
    volumes:
{% if frontend %}
      - {{ buckram }}/containers/nginx/laravel-dev-frontend:/etc/nginx/conf.d/default.conf
{% else %}
      - {{ buckram }}/containers/nginx/laravel-dev:/etc/nginx/conf.d/default.conf
{% endif %}
      - {{ docker }}/certificates:/secrets
      - {{ laravel }}:/var/www/app
    env_file:
      - {{ docker }}/config/laravel.env
    ports:
      - "8000:80"
    links:
      - phpfpm:phpfpm
    environment:
      LARAVEL_ROOT: "/var/www/app"
  artisan_worker:
    restart: on-failure
    build:
      context: {{ buckram }}/containers/phpfpm
      dockerfile: Dockerfile.debug
    volumes:
      - {{ laravel }}:/var/www/app
    env_file:
      - {{ docker }}/config/laravel.env
      - {{ docker }}/config/redis.env
    environment:
      REDIS_HOST: "redis"
      REDIS_PORT: 6379
      APP_DEBUG: 1
      ALLOW_HTTP_URL: 1
    links:
      - db:db
      - redis:redis
    entrypoint:
      - php
      - /var/www/app/artisan
    command:
      - "queue:work"
      - --tries=3
  redis:
    image: redis
    env_file:
      - {{ docker }}/config/redis.env
