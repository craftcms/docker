# Craft Docker Images

These images are used for a baseline to extend for your Docker deployments.

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
2. `nginx` service that will accept HTTP requests on port 8000
3. `mysql` service that will store your content
4. `queue` service that will run the queue locally
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
  queue:
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

You will need to provide an nginx.conf file that points the `php-fpm` service, not `localhost` or `127.0.0.1`. We can borrow the following example from [nystudio107/nginx-craft](https://github.com/nystudio107/nginx-craft) in the `sites-available/basic_localdev.com.conf` and update it to use

```nginx
# removed comments for readability except where we modify the config
server {
    listen 80;
    listen [::]:80;

    server_name _;
    # we change the root to match the root for the php-fpm service
    root /app/web;
    index index.html index.htm index.php;
    charset utf-8;

    gzip_static  on;

    ssi on;

    client_max_body_size 0;

    error_page 404 /index.php?$query_string;

    access_log off;
    error_log /dev/stdout info;

    # Root directory location handler
    location / {
        try_files $uri/index.html $uri $uri/ /index.php?$query_string;
    }

    # php-fpm configuration
    location ~ [^/]\.php(/|$) {
        try_files $uri $uri/ /index.php?$query_string;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        # instead of localhost of 127.0.0.1, we use the name of the service for php-fpm
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param HTTP_PROXY "";

        # Don't allow browser caching of dynamically generated content
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
