ARG PHP_VERSION=7.4
ARG PROJECT_TYPE=fpm
FROM craftcms/php-${PROJECT_TYPE}:${PHP_VERSION}-dev

USER root

RUN set -ex && \
    apk --no-cache add \
        autoconf \
        g++ \
        make && \
    pecl install xdebug && \
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    docker-php-ext-enable xdebug && \
    apk del --no-cache \
        autoconf \
        g++ \
        make

USER www-data
