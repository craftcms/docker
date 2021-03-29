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
    mariadb-connector-c \
    nodejs \
    npm \
    postgresql-client \
    && \
    pecl install xdebug && \
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    docker-php-ext-enable xdebug && \
    apk del --no-cache \
    autoconf \
    g++ \
    make

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# expose the xdebug port
EXPOSE 9003

# expose additional ports for node
EXPOSE 3000 3001

USER www-data
