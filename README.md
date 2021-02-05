# Craft Docker Images

These images are provided as a starting point for your Docker-based Craft CMS deployments. They’re discrete, lightweight, and pre-configured to meet Craft’s requirements in production and development environments.

## Images

There are three main "types" of images provided for different types of applications; `php-fpm`, `nginx`, and `cli`. Each image allows the developer to select a PHP version (e.g. `craftcms/nginx:7.4`).

Each image and PHP version also provides a `-dev` variant which has Xdebug installed and is useful for local development (e.g. `craftcms/php-fpm:7.4-dev`). Images that do not include `-dev` are considered production.

> Note: you are not required to use `-dev` images for local development, they are provided with Xdebug to make debugging easier.

### php-fpm

[![craftcms/php-fpm](https://img.shields.io/docker/pulls/craftcms/php-fpm.svg)](https://hub.docker.com/r/craftcms/php-fpm)

The `php-fpm` image is provided as the base image (and is also used for the `nginx` image) and requires you "bring your own server".

| Image                      | Use | Environment   |
|----------------------------|-----|---------------|
| `craftcms/php-fpm:8.0`     | web | `production`  |
| `craftcms/php-fpm:8.0-dev` | web | `development` |
| `craftcms/php-fpm:7.4`     | web | `production`  |
| `craftcms/php-fpm:7.4-dev` | web | `development` |
| `craftcms/php-fpm:7.3`     | web | `production`  |
| `craftcms/php-fpm:7.3-dev` | web | `development` |
| `craftcms/php-fpm:7.2`     | web | `production`  |
| `craftcms/php-fpm:7.2-dev` | web | `development` |
| `craftcms/php-fpm:7.1`     | web | `production`  |
| `craftcms/php-fpm:7.1-dev` | web | `development` |
| `craftcms/php-fpm:7.0`     | web | `production`  |
| `craftcms/php-fpm:7.0-dev` | web | `development` |

### Nginx

[![craftcms/nginx](https://img.shields.io/docker/pulls/craftcms/nginx.svg)](https://hub.docker.com/r/craftcms/nginx)

The `nginx` image is used for a typical installation and includes an Nginx server configured for Craft CMS and php-fpm.

| Image                    | Use | Environment   |
|--------------------------|-----|---------------|
| `craftcms/nginx:8.0`     | web | `production`  |
| `craftcms/nginx:8.0-dev` | web | `development` |
| `craftcms/nginx:7.4`     | web | `production`  |
| `craftcms/nginx:7.4-dev` | web | `development` |
| `craftcms/nginx:7.3`     | web | `production`  |
| `craftcms/nginx:7.3-dev` | web | `development` |
| `craftcms/nginx:7.2`     | web | `production`  |
| `craftcms/nginx:7.2-dev` | web | `development` |
| `craftcms/nginx:7.1`     | web | `production`  |
| `craftcms/nginx:7.1-dev` | web | `development` |
| `craftcms/nginx:7.0`     | web | `production`  |
| `craftcms/nginx:7.0-dev` | web | `development` |

### cli

[![craftcms/cli](https://img.shields.io/docker/pulls/craftcms/cli.svg)](https://hub.docker.com/r/craftcms/cli)

The image type `cli` which is used to run queues, migrations, etc. and the image does not expose ports for HTTP/S or PHP-FPM.

| Image                      | Use   | Environment   |
|----------------------------|-------|---------------|
| `craftcms/cli:8.0`         | queue | `production`  |
| `craftcms/cli:8.0-dev`     | queue | `development` |
| `craftcms/cli:7.4`         | queue | `production`  |
| `craftcms/cli:7.4-dev`     | queue | `development` |
| `craftcms/cli:7.3`         | queue | `production`  |
| `craftcms/cli:7.3-dev`     | queue | `development` |
| `craftcms/cli:7.2`         | queue | `production`  |
| `craftcms/cli:7.2-dev`     | queue | `development` |
| `craftcms/cli:7.1`         | queue | `production`  |
| `craftcms/cli:7.1-dev`     | queue | `development` |
| `craftcms/cli:7.0`         | queue | `production`  |
| `craftcms/cli:7.0-dev`     | queue | `development` |

## Usage

There are two main types of images: `php-fpm` for handling the web application, and `cli` for running queues and other Craft CLI commands.

> Note: We purposely do not provide a web server image because that choice depends on your project needs. We do, however, provide examples illustrating how to use Nginx or Caddy with the `php-fpm` images.

This example uses a Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to install composer dependencies inside a separate layer before copying them into the final image.

```dockerfile
# use a multi-stage build for dependencies
FROM composer:1 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/php-fpm:7.4

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

This example uses the `craftcms/nginx` repository and installs the `mysql-client` tools to enable backups from the Craft CMS control panel.

```dockerfile
# composer dependencies
FROM composer:1 as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:7.4

# switch to the root user to install mysql tools
USER root
RUN apk add --no-cache mysql-client
USER www-data

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data . .
```

## Permissions

The image is designed to be run by a `www-data` user that owns of the image’s `/app` directory. Running as non-root is considered a Docker best practice, especially when shipping container images to production.

> Note: You can use the `USER root` directive to switch back to `root` to install any additional packages you need.

## Running Locally with Docker Compose

We recommend running Docker locally if you’re shipping your project to a Docker-based envrionment such as Amazon Web Services Elastic Container Services (ECS). The following Docker Compose file will setup your local environment with the following:

1. `web` service that will handle running PHP and Nginx
2. `mysql` service that will store your content
3. `console` service that will run the queue locally
4. `redis` service that will handle queue and caching

```yaml
version: "3.6"
services:
  web:
    image: craftcms/nginx:7.4-dev
    volumes:
      - .:/app
    ports:
      - 8080:8080
    env_file: .env
  console:
    image: craftcms/cli:7.4-dev
    volumes:
      - .:/app
    env_file: .env
    command: ["./craft", "queue/listen"]
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

This image is based off the [official Docker PHP FPM image](https://hub.docker.com/_/php) (Alpine Linux). Therefore you can use all of the tools to install PHP extensions. To install an extension, you have to switch to the `root` user. This example switches to the `root` user to install the [`sockets` extension](https://www.php.net/manual/en/book.sockets.php) for PHP 7.4. Note that it switches back to `www-data` after installation:

```dockerfile
FROM craftcms/php-fpm:7.4

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
    image: craftcms/php-fpm:7.4-dev
    volumes:
      - .:/app
    env_file: .env
    environment:
      PHP_MEMORY_LIMIT: 512M
  # ...
```

### Customizable Settings

| PHP Setting                       | Environment Variable                  | Default Value |
|-----------------------------------|---------------------------------------|---------------|
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
