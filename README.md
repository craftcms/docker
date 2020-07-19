# Craft Docker Images

## Images

| Image                      | Purpose           |
|----------------------------|-------------------|
| `craftcms/php-fpm:7.4`     | Production use    |
| `craftcms/php-fpm:7.4-dev` | Local development |
| `craftcms/php-fpm:7.3`     | Production use    |
| `craftcms/php-fpm:7.3-dev` | Local development |

## Example Usage

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
