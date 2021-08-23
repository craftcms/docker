# Craft Docker Images

These images are a starting point for your Docker-based Craft CMS deployments. They’re discrete, lightweight, and pre-configured to meet Craft’s requirements for production and development environments.

## Images

There are three main “types” of images: [`php-fpm`](#php-fpm), [`nginx`](#nginx), and [`cli`](#cli). These are production-ready, and each allows the developer to select a PHP version (e.g. `craftcms/nginx:8.0`). Each one also a `-dev` variant (e.g. `craftcms/php-fpm:8.0-dev`) for local development with Xdebug and database tools for managing backups.

> 💡 Database tools are only included in `-dev` image variants. If you’d like to create database backups from the Craft CMS control panel using the production images, you’ll need to [install the database tools](#database-tools) yourself.

Our Docker image PHP versions align with [PHP’s official support](https://www.php.net/supported-versions.php), meaning that once a PHP version is EOL, we will no longer build new images for that version.

### php-fpm

[![craftcms/php-fpm](https://img.shields.io/docker/pulls/craftcms/php-fpm.svg)](https://hub.docker.com/r/craftcms/php-fpm)

The `php-fpm` image is a base image and does not include a web server.

| Image                         | Use | Environment   | Status |
| ----------------------------- | --- | ------------- | ------ |
| `craftcms/php-fpm:8.1-rc`     | web | `production`  | RC     |
| `craftcms/php-fpm:8.1-rc-dev` | web | `development` | RC     |
| `craftcms/php-fpm:8.0`        | web | `production`  |        |
| `craftcms/php-fpm:8.0-dev`    | web | `development` |        |
| `craftcms/php-fpm:7.4`        | web | `production`  |        |
| `craftcms/php-fpm:7.4-dev`    | web | `development` |        |
| `craftcms/php-fpm:7.3`        | web | `production`  |        |
| `craftcms/php-fpm:7.3-dev`    | web | `development` |        |
| `craftcms/php-fpm:7.2`        | web | `production`  | EOL    |
| `craftcms/php-fpm:7.2-dev`    | web | `development` | EOL    |
| `craftcms/php-fpm:7.1`        | web | `production`  | EOL    |
| `craftcms/php-fpm:7.1-dev`    | web | `development` | EOL    |
| `craftcms/php-fpm:7.0`        | web | `production`  | EOL    |
| `craftcms/php-fpm:7.0-dev`    | web | `development` | EOL    |

### Nginx

[![craftcms/nginx](https://img.shields.io/docker/pulls/craftcms/nginx.svg)](https://hub.docker.com/r/craftcms/nginx)

The `nginx` image builds upon the `php-fpm` image to provide an Nginx server that’s ready to run a typical Craft CMS installation with php-fpm.

| Image                       | Use | Environment   | Status |
| --------------------------- | --- | ------------- | ------ |
| `craftcms/nginx:8.1-rc`     | web | `production`  | RC     |
| `craftcms/nginx:8.1-rc-dev` | web | `development` | RC     |
| `craftcms/nginx:8.0`        | web | `production`  |        |
| `craftcms/nginx:8.0-dev`    | web | `development` |        |
| `craftcms/nginx:7.4`        | web | `production`  |        |
| `craftcms/nginx:7.4-dev`    | web | `development` |        |
| `craftcms/nginx:7.3`        | web | `production`  |        |
| `craftcms/nginx:7.3-dev`    | web | `development` |        |
| `craftcms/nginx:7.2`        | web | `production`  | EOL    |
| `craftcms/nginx:7.2-dev`    | web | `development` | EOL    |
| `craftcms/nginx:7.1`        | web | `production`  | EOL    |
| `craftcms/nginx:7.1-dev`    | web | `development` | EOL    |
| `craftcms/nginx:7.0`        | web | `production`  | EOL    |
| `craftcms/nginx:7.0-dev`    | web | `development` | EOL    |

### cli

[![craftcms/cli](https://img.shields.io/docker/pulls/craftcms/cli.svg)](https://hub.docker.com/r/craftcms/cli)

The `cli` image is for terminal-only Craft interaction like to running queues, migrations, etc. The image does not expose ports for HTTP/S or php-fpm.

| Image                     | Use | Environment   | Status |
| ------------------------- | --- | ------------- | ------ |
| `craftcms/cli:8.1-rc`     | web | `production`  | RC     |
| `craftcms/cli:8.1-rc-dev` | web | `development` | RC     |
| `craftcms/cli:8.0`        | web | `production`  |        |
| `craftcms/cli:8.0-dev`    | web | `development` |        |
| `craftcms/cli:7.4`        | web | `production`  |        |
| `craftcms/cli:7.4-dev`    | web | `development` |        |
| `craftcms/cli:7.3`        | web | `production`  |        |
| `craftcms/cli:7.3-dev`    | web | `development` |        |
| `craftcms/cli:7.2`        | web | `production`  | EOL    |
| `craftcms/cli:7.2-dev`    | web | `development` | EOL    |
| `craftcms/cli:7.1`        | web | `production`  | EOL    |
| `craftcms/cli:7.1-dev`    | web | `development` | EOL    |
| `craftcms/cli:7.0`        | web | `production`  | EOL    |
| `craftcms/cli:7.0-dev`    | web | `development` | EOL    |

## Usage

This example uses a Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to install composer dependencies inside a separate layer before copying them into the final image.

```dockerfile
# use a multi-stage build for dependencies
FROM composer:2 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/php-fpm:8.0

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

### Database Tools

This example uses the `nginx` image and installs the database tools to enable backups from the Craft CMS control panel:

```dockerfile
# composer dependencies
FROM composer:2 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:8.0

# switch to the root user to install mysql tools
USER root
RUN apk add --no-cache mysql-client postgres-client
USER www-data

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

## Permissions

The images are designed to be run by a `www-data` user that owns of the image’s `/app` directory. Running as non-root is considered a Docker best practice, especially when shipping container images to production.

> 💡 You can use the `USER root` directive to switch to `root` and install any packages you need.

## Running Locally with Docker Compose

We recommend running Docker locally if you’re shipping your project to a Docker-based environment like Amazon Web Services Elastic Container Service (ECS). The following Docker Compose file will set up your local environment with the following:

1. `web` service that will handle running PHP and Nginx
2. `postgres` service that will store your content
3. `console` service that will run the queue locally
4. `redis` service that will handle queue and caching

```yaml
version: "3.6"
services:
  console:
    image: craftcms/cli:8.0-dev
    env_file: .env
    environment:
      XDEBUG_CONFIG: client_host=host.docker.internal
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - .:/app
    command: php craft queue/listen

  web:
    image: craftcms/nginx:8.0-dev
    ports:
      - 8080:8080
    env_file: .env
    environment:
      XDEBUG_CONFIG: client_host=host.docker.internal
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - .:/app

  postgres:
    image: postgres:13-alpine
    ports:
      - 5432:5432
    environment:
      POSTGRES_DB: dev_craftcms
      POSTGRES_USER: craftcms
      POSTGRES_PASSWORD: SecretPassword
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "pg_isready"]
      interval: 5s
      retries: 3

  redis:
    image: redis:5-alpine
    ports:
      - 6379:6379
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]

volumes:
  db_data:
```

## Using Xdebug

Xdebug is included with the `-dev` image variants, but you still need to set `xdebug.client_host`.
We don’t do this in our images because it’s platform-specific. If you’re using Docker Desktop for macOS or Windows, you can use `host.docker.internal`.

This can be done via environment variable: `XDEBUG_CONFIG=client_host=host.docker.internal`. [See example](#running-locally-with-docker-compose)

## Installing Extensions

This image is based on the [official Docker PHP-FPM image](https://hub.docker.com/_/php) (Alpine Linux), where you can use included tools to install PHP extensions as the `root` user.

This example switches to the `root` user to install the [`sockets` extension](https://www.php.net/manual/en/book.sockets.php) for PHP 8.0. Note that it switches back to `www-data` after installation:

```dockerfile
FROM craftcms/php-fpm:8.0

# switch to the root user
USER root
RUN docker-php-ext-install sockets
USER www-data

# the user is www-data, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

## Customizing PHP Settings

Some PHP settings may be customized by setting environment variables for the `php-fpm` or `cli` images.

In this example, we’re setting the PHP memory limit to `512M` rather than the default `256M`:

```yaml
version: "3.6"
services:
  php-fpm:
    image: craftcms/php-fpm:8.0-dev
    volumes:
      - .:/app
    env_file: .env
    environment:
      PHP_MEMORY_LIMIT: 512M
  # ...
```

### Customizable Settings

| PHP Setting                       | Environment Variable                  | Default Value |
| --------------------------------- | ------------------------------------- | ------------- |
| `memory_limit`                    | `PHP_MEMORY_LIMIT`                    | `256M`        |
| `max_execution_time`              | `PHP_MAX_EXECUTION_TIME`              | `120`         |
| `upload_max_filesize`             | `PHP_UPLOAD_MAX_FILESIZE`             | `20M`         |
| `max_input_vars`                  | `PHP_MAX_INPUT_VARS`                  | `1000`        |
| `post_max_size`                   | `PHP_POST_MAX_SIZE`                   | `8M`          |
| `opcache.enable`                  | `PHP_OPCACHE_ENABLE`                  | `1`           |
| `opcache.revalidate_freq`         | `PHP_OPCACHE_REVALIDATE_FREQ`         | `0`           |
| `opcache.validate_timestamps`     | `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | `0`           |
| `opcache.max_accelerated_files`   | `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | `10000`       |
| `opcache.memory_consumption`      | `PHP_OPCACHE_MEMORY_CONSUMPTION`      | `256`         |
| `opcache.max_wasted_percentage`   | `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`   | `10`          |
| `opcache.interned_strings_buffer` | `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `16`          |
| `opcache.fast_shutdown`           | `PHP_OPCACHE_FAST_SHUTDOWN`           | `1`           |
