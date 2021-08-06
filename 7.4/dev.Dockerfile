ARG PHP_VERSION
ARG PROJECT_TYPE
FROM craftcms/${PROJECT_TYPE}:${PHP_VERSION}

# disable opcache
ENV PHP_OPCACHE_ENABLE=0

USER root

COPY craft-cms-xdebug.ini /usr/local/etc/php/conf.d

RUN set -ex \
    && apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
    && apk --no-cache add \
    git \
    mariadb-connector-c \
    mysql-client \
    nodejs \
    npm \
    postgresql-client \
    && pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini\
    && docker-php-ext-enable xdebug \
    && apk del --no-network .build-deps

# install composer
RUN set -ex && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# expose the xdebug port
EXPOSE 9003

# expose additional ports for node
EXPOSE 3000 3001

USER www-data
