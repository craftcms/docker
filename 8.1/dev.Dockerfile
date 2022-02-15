ARG PHP_VERSION
ARG PROJECT_TYPE
FROM craftcms/${PROJECT_TYPE}:${PHP_VERSION}

# disable opcache
ENV PHP_OPCACHE_ENABLE=0

USER root

COPY craft-cms-xdebug.ini /usr/local/etc/php/conf.d/

RUN set -ex \
    && apk upgrade --no-cache \
    && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
    && apk --no-cache add \
    git \
    mariadb-connector-c \
    mysql-client \
    nodejs \
    npm \
    postgresql-client \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del --no-network .build-deps

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# expose additional ports for node
EXPOSE 3000 3001

USER www-data
