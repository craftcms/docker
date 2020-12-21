ARG PHP_VERSION
FROM craftcms/php-fpm:${PHP_VERSION}

# install supervisor and nginx
USER root
RUN apk update --no-cache && apk add --no-cache supervisor nginx
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY craftcms/general.conf /etc/nginx/craftcms/
COPY craftcms/php_fastcgi.conf /etc/nginx/craftcms/
COPY craftcms/security.conf /etc/nginx/craftcms/
COPY default.conf /etc/nginx/conf.d/default.conf
RUN touch /run/nginx.pid
RUN touch /run/supervisord.pid
RUN chown www-data /run/nginx.pid
RUN chown www-data /run/supervisord.pid
RUN chown -R www-data:www-data /var/lib/nginx/logs/
USER www-data

EXPOSE 8080
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]

# ONBUILD COPY --chown=www-data:www-data . .
