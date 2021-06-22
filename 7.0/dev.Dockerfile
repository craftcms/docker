ARG PHP_VERSION
ARG PROJECT_TYPE
FROM craftcms/${PROJECT_TYPE}:${PHP_VERSION}

# disable opcache
ENV PHP_OPCACHE_ENABLE=0

USER root

RUN set -ex && \
    apk --no-cache add \
    autoconf \
    g++ \
    git \
    make \
    mysql-client \
    nodejs \
    postgresql-client \
    && \
    apk del --no-cache \
    autoconf \
    g++ \
    make

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# downgrade composer to version 1
RUN set -ex && composer self-update --1

# expose additional ports for node
EXPOSE 3000 3001

USER www-data
