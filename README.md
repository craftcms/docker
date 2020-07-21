# Craft Docker Images

## Images

| Image                      | Purpose           |
|----------------------------|-------------------|
| `craftcms/php-fpm:7.4`     | Production use    |
| `craftcms/php-fpm:7.4-dev` | Local development |
| `craftcms/cli:7.4`         | Production use    |
| `craftcms/cli:7.4-dev`     | Local development |
| `craftcms/php-fpm:7.3`     | Production use    |
| `craftcms/php-fpm:7.3-dev` | Local development |
| `craftcms/cli:7.3`         | Production use    |
| `craftcms/cli:7.3-dev`     | Local development |

## Usage

Craft provides two main types of images, a `php-fpm` and `cli` image. The `php-fpm` image is used to handle the web application and the `cli` is used to run queues.

> Note: We purposely do not provide a web server image as that choice depends on your project needs. We do provide documentation on how to use Nginx and Caddy with this image

This example uses a Docker multi-stage build to install composer dependencies inside a seperate layer and then copy them into the final image.

```dockerfile
# use a multi-stage build for dependencies
FROM composer:1 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/php-fpm:7.4

# the user is www-data, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

## Permissions

The image is set to run as the user `www-data`. There is a directory already precreated and prepared for the `www-data` user. Running as non-root is considered a Docker best practice, especially when shipping container images to production.

> Note: You can use the `USER root` directive to switch back to `root` to install any additional packages you need.

## Running Locally with Docker Compose

Running Docker locally is recommended if you are shipping your project to a Docker based envrionment such as Amazon Web Services Elastic Container Services (ECS). The following Docker Compose file will setup your local environment with the following:

1. `php-fpm` service that will handle running PHP
2. An `nginx` service that will accept HTTP requests on port 8000
3. A `mysql` service that will store your content
4. A `queue` service that will run the queue locally
5. A `redis` service that will handle queue and caching

```yaml
version: "3.6"
services:
  php-fpm:
    image: craftcms/php-fpm:7.4-dev
    volumes:
      - .:/app
    env_file: .env
  queue:
    image: craftcms/cli:7.4-dev
    volumes:
      - .:/app
    env_file: .env
    command: ["./craft", "queue/listen"]
  nginx:
    image: nginx:stable-alpine
    ports:
      - 8000:80
  mysql:
    image: mysql:8.0
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: SuperPassword123456!
      MYSQL_DATABASE: dev_craftcms
      MYSQL_USER: craftcms
      MYSQL_PASSWORD: SecretPassword
    volumes:
      - db_data:/var/lib/mysql
  redis:
    image: redis:5-alpine
    ports:
      - 6379:6379
volumes:
  db_data:
```

## Installing Extensions

This image is based off the official Docker PHP FPM image (Alpine Linux). Therefore you can use all of the tools to install PHP extensions. To install an extension, you have to switch to the `root` user.

```dockerfile
FROM craftcms/php-fpm:7.4

USER root
RUN docker-php-ext-install sockets
USER www-data

# the user is www-data, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```
