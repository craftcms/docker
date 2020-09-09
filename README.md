# Craft Docker Images

[![craftcms/php-fpm](https://img.shields.io/docker/pulls/craftcms/php-fpm.svg)](https://hub.docker.com/r/craftcms/php-fpm)
[![craftcms/cli](https://img.shields.io/docker/pulls/craftcms/cli.svg)](https://hub.docker.com/r/craftcms/cli)
[![craftcms/nginx](https://img.shields.io/docker/pulls/craftcms/nginx.svg)](https://hub.docker.com/r/craftcms/nginx)

These images are provided as a starting point for your Docker-based Craft CMS deployments. They’re discrete, lightweight, and preconfigured to meet Craft’s requirements in production and development environments.

## Images

| Image                      | Use   | Environment   |
|----------------------------|-------|---------------|
| `craftcms/nginx:7.4`       | web   | `production`  |
| `craftcms/nginx:7.3`       | web   | `production`  |
| `craftcms/php-fpm:7.4`     | web   | `production`  |
| `craftcms/php-fpm:7.4-dev` | web   | `development` |
| `craftcms/php-fpm:7.3`     | web   | `production`  |
| `craftcms/php-fpm:7.3-dev` | web   | `development` |
| `craftcms/cli:7.4`         | queue | `production`  |
| `craftcms/cli:7.4-dev`     | queue | `development` |
| `craftcms/cli:7.3`         | queue | `production`  |
| `craftcms/cli:7.3-dev`     | queue | `development` |

## Usage

There are two main types of images: `php-fpm` for handling the web application, and `cli` for running queues and other Craft CLI commands.

> Note: We purposely do not provide a web server image because that choice depends on your project needs. We do, however, provide examples illustrating how to use Nginx or Caddy with the `php-fpm` images.

This example uses a Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) to install composer dependencies inside a seperate layer before copying them into the final image.

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

1. `nginx` service that will accept HTTP requests on port 8000
2. `php-fpm` service that will handle running PHP
3. `mysql` service that will store your content
4. `console` service that will run the queue locally
5. `redis` service that will handle queue and caching

```yaml
version: "3.6"
services:
  php-fpm:
    image: craftcms/php-fpm:7.4-dev
    volumes:
      - .:/app
    env_file: .env
  nginx:
    image: nginx:stable-alpine
    ports:
      - 8000:80
    volumes:
      - ./path/to/nginx.conf:/etc/nginx/conf.d/default.conf
      - .:/app
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

You will need to provide an `nginx.conf` file that points the `php-fpm` service, not `localhost` or `127.0.0.1`. We can borrow the following example from [nystudio107/nginx-craft](https://github.com/nystudio107/nginx-craft)’s `sites-available/basic_localdev.com.conf` with a few adjustments:

- remove comments for readibility
- use a catch-all `server_name` of `_`
- set `/app/web` as the web root
- log to stdout
- direct PHP to our named `php-fpm` service instead of localhost (on its default port `9000`)
- unset the `HTTP_HOST` header
- remove Dotenvy, `.htaccess` file skipping, and `sendfile off` that aren’t needed

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name _;
    root /app/web;
    index index.html index.htm index.php;
    charset utf-8;

    gzip_static  on;

    ssi on;

    client_max_body_size 0;

    error_page 404 /index.php?$query_string;

    access_log off;
    error_log /dev/stdout info;

    location / {
        try_files $uri/index.html $uri $uri/ /index.php?$query_string;
    }

    location ~ [^/]\.php(/|$) {
        try_files $uri $uri/ /index.php?$query_string;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param HTTP_PROXY "";

        add_header Last-Modified $date_gmt;
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
        if_modified_since off;
        expires off;
        etag off;

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
}
```

## Installing Extensions

This image is based off the [official Docker PHP FPM image](https://hub.docker.com/_/php) (Alpine Linux). Therefore you can use all of the tools to install PHP extensions. To install an extension, you have to switch to the `root` user. This example switches to the `root` user to install the [`sockets` extension](https://www.php.net/manual/en/book.sockets.php) for PHP 7.4. Note that it switches back to `www-data` after installation:

```dockerfile
FROM craftcms/php-fpm:7.4

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
