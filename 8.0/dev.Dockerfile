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
    mariadb-connector-c \
    postgresql-client \
    git \
    && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    apk del --no-cache \
    autoconf \
    g++ \
    make

# download node versions
RUN mkdir -p /opt/node_versions
RUN wget -O /opt/node_versions/nodejs-10.apk https://dl-cdn.alpinelinux.org/alpine/v3.10/main/$(uname -m)/nodejs-10.24.0-r0.apk
RUN wget -O /opt/node_versions/npm-10.apk https://dl-cdn.alpinelinux.org/alpine/v3.10/main/$(uname -m)/npm-10.24.0-r0.apk
RUN wget -O /opt/node_versions/nodejs-12.apk https://dl-cdn.alpinelinux.org/alpine/v3.12/main/$(uname -m)/nodejs-12.21.0-r0.apk
RUN wget -O /opt/node_versions/npm-12.apk https://dl-cdn.alpinelinux.org/alpine/v3.12/main/$(uname -m)/npm-12.21.0-r0.apk
RUN wget -O /opt/node_versions/nodejs-14.apk https://dl-cdn.alpinelinux.org/alpine/v3.13/main/$(uname -m)/nodejs-14.16.0-r0.apk
RUN wget -O /opt/node_versions/npm-14.apk https://dl-cdn.alpinelinux.org/alpine/v3.13/main/$(uname -m)/npm-14.16.0-r0.apk

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# expose webpack devserver port
EXPOSE 3000

USER www-data
