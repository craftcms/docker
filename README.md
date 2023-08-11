# Craft Docker Images

These images are provided as a starting point for your Docker-based Craft CMS deployments. They’re discrete, lightweight, and pre-configured to meet Craft’s requirements in production and development environments.

## Images

There are three main "types" of images provided for different types of applications; `php-fpm`, `nginx`, and `cli`. Each image allows the developer to select a PHP version (e.g. `craftcms/nginx:8.2`).

Each image and PHP version also provides a `-dev` variant which has Xdebug installed and is useful for local development (e.g. `craftcms/php-fpm:8.2-dev`), as well as database tools for creating and restoring backups. Images that do not include `-dev` are considered production.

> Note: you are not required to use `-dev` images for local development, they are provided with Xdebug and to make debugging easier.

To keep the production images lean and secure, database tools are NOT included by default (they are included in the `-dev` variants). If you want to create database backups from the Craft control panel, you will need to [install these yourself](#database-tools).

Supported PHP versions are aligned with [PHP's official support](https://www.php.net/supported-versions.php), meaning that once a PHP version is EOL, we will no longer build new images for that version.

### php-fpm

[![craftcms/php-fpm](https://img.shields.io/docker/pulls/craftcms/php-fpm.svg)](https://hub.docker.com/r/craftcms/php-fpm)

The `php-fpm` image is provided as the base image (and is also used for the `nginx` image) and requires you "bring your own server".

| Image                      | Use | Environment   | Status |
| -------------------------- | --- | ------------- | ------ |
| `craftcms/php-fpm:8.2`     | web | `production`  |        |
| `craftcms/php-fpm:8.2-dev` | web | `development` |        |
| `craftcms/php-fpm:8.1`     | web | `production`  |        |
| `craftcms/php-fpm:8.1-dev` | web | `development` |        |
| `craftcms/php-fpm:8.0`     | web | `production`  |        |
| `craftcms/php-fpm:8.0-dev` | web | `development` |        |
| `craftcms/php-fpm:7.4`     | web | `production`  |        |
| `craftcms/php-fpm:7.4-dev` | web | `development` |        |
| `craftcms/php-fpm:7.3`     | web | `production`  |        |
| `craftcms/php-fpm:7.3-dev` | web | `development` |        |
| `craftcms/php-fpm:7.2`     | web | `production`  | EOL    |
| `craftcms/php-fpm:7.2-dev` | web | `development` | EOL    |
| `craftcms/php-fpm:7.1`     | web | `production`  | EOL    |
| `craftcms/php-fpm:7.1-dev` | web | `development` | EOL    |
| `craftcms/php-fpm:7.0`     | web | `production`  | EOL    |
| `craftcms/php-fpm:7.0-dev` | web | `development` | EOL    |

### Nginx

[![craftcms/nginx](https://img.shields.io/docker/pulls/craftcms/nginx.svg)](https://hub.docker.com/r/craftcms/nginx)

The `nginx` image is used for a typical installation and includes an Nginx server configured for Craft CMS and php-fpm.

| Image                    | Use | Environment   | Status |
| ------------------------ | --- | ------------- | ------ |
| `craftcms/nginx:8.2`     | web | `production`  |        |
| `craftcms/nginx:8.2-dev` | web | `development` |        |
| `craftcms/nginx:8.1`     | web | `production`  |        |
| `craftcms/nginx:8.1-dev` | web | `development` |        |
| `craftcms/nginx:8.0`     | web | `production`  |        |
| `craftcms/nginx:8.0-dev` | web | `development` |        |
| `craftcms/nginx:7.4`     | web | `production`  |        |
| `craftcms/nginx:7.4-dev` | web | `development` |        |
| `craftcms/nginx:7.3`     | web | `production`  |        |
| `craftcms/nginx:7.3-dev` | web | `development` |        |
| `craftcms/nginx:7.2`     | web | `production`  | EOL    |
| `craftcms/nginx:7.2-dev` | web | `development` | EOL    |
| `craftcms/nginx:7.1`     | web | `production`  | EOL    |
| `craftcms/nginx:7.1-dev` | web | `development` | EOL    |
| `craftcms/nginx:7.0`     | web | `production`  | EOL    |
| `craftcms/nginx:7.0-dev` | web | `development` | EOL    |

### cli

[![craftcms/cli](https://img.shields.io/docker/pulls/craftcms/cli.svg)](https://hub.docker.com/r/craftcms/cli)

The image type `cli` which is used to run queues, migrations, etc. and the image does not expose ports for HTTP/S or PHP-FPM.

| Image                  | Use | Environment   | Status |
| ---------------------- | --- | ------------- | ------ |
| `craftcms/cli:8.2`     | web | `production`  |        |
| `craftcms/cli:8.2-dev` | web | `development` |        |
| `craftcms/cli:8.1`     | web | `production`  |        |
| `craftcms/cli:8.1-dev` | web | `development` |        |
| `craftcms/cli:8.0`     | web | `production`  |        |
| `craftcms/cli:8.0-dev` | web | `development` |        |
| `craftcms/cli:7.4`     | web | `production`  |        |
| `craftcms/cli:7.4-dev` | web | `development` |        |
| `craftcms/cli:7.3`     | web | `production`  |        |
| `craftcms/cli:7.3-dev` | web | `development` |        |
| `craftcms/cli:7.2`     | web | `production`  | EOL    |
| `craftcms/cli:7.2-dev` | web | `development` | EOL    |
| `craftcms/cli:7.1`     | web | `production`  | EOL    |
| `craftcms/cli:7.1-dev` | web | `development` | EOL    |
| `craftcms/cli:7.0`     | web | `production`  | EOL    |
| `craftcms/cli:7.0-dev` | web | `development` | EOL    |

## Usage

There are two main types of images: `php-fpm` for handling the web application, and `cli` for running queues and other Craft CLI commands. Additionally, we provide an `nginx` image, which combines `php-fpm` and `nginx` into a single image for simplicity and ease of development.

This example uses a Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to install composer dependencies inside a separate layer before copying them into the final image.

```dockerfile
# use a multi-stage build for dependencies
FROM composer:2 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/php-fpm:8.2

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

### Database tools

This example uses the `craftcms/nginx` repository and installs the database tools to enable backups from the Craft CMS control panel. Note: These will be included automatically if using the `-dev` image variants.

```dockerfile
# composer dependencies
FROM composer:2 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:8.2

# switch to the root user to install mysql tools
USER root
RUN apk add --no-cache mysql-client postgresql-client
USER www-data

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

## Permissions

The image is designed to be run by a `www-data` user that owns of the image’s `/app` directory. Running as non-root is considered a Docker best practice, especially when shipping container images to production.

> Note: You can use the `USER root` directive to switch back to `root` to install any additional packages you need.

## Running Locally with Docker Compose

We recommend running Docker locally if you’re shipping your project to a Docker-based environment such as Amazon Web Services Elastic Container Services (ECS). The following Docker Compose file will setup your local environment with the following:

1. `web` service that will handle running PHP and Nginx
2. `postgres` service that will store your content
3. `console` service that will run the queue locally
4. `redis` service that will handle queue and caching

```yaml
version: "3.6"
services:
  console:
    image: craftcms/cli:8.2-dev
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
    image: craftcms/nginx:8.2-dev
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
      test: ["CMD", "pg_isready", "-U", "craftcms", "-d", "dev_craftcms"]
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

Xdebug is install on the `-dev` image variants, but you will still need to set `xdebug.client_host`.
We do not do this in our images, as it is platform-specific. However, if you are on Docker Desktop for Mac or Windows, you can use `host.docker.internal`.

This can be done via environment variable: `XDEBUG_CONFIG=client_host=host.docker.internal`. [See example](#running-locally-with-docker-compose)

## Installing Extensions

This image is based off the [official Docker PHP FPM image](https://hub.docker.com/_/php) (Alpine Linux). Therefore you can use all of the tools to install PHP extensions. To install an extension, you have to switch to the `root` user. This example switches to the `root` user to install the [`sockets` extension](https://www.php.net/manual/en/book.sockets.php) for PHP 8.2. Note that it switches back to `www-data` after installation:

```dockerfile
FROM craftcms/php-fpm:8.2

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
    image: craftcms/php-fpm:8.2-dev
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
