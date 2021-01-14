ARG PHP_VERSION
ARG PROJECT_TYPE
FROM craftcms/${PROJECT_TYPE}:${PHP_VERSION}

# disable opcache
ENV PHP_OPCACHE_ENABLE=0

USER root

COPY craft-cms-xdebug.ini /usr/local/etc/php/conf.d

RUN set -ex && \
    apk --no-cache add \
    autoconf \
    g++ \
    make \
    mysql-client \
    postgresql-client \
    && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    apk del --no-cache \
    autoconf \
    g++ \
    make

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

USER www-data
