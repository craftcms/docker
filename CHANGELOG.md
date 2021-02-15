# Release Notes for Craft CMS Docker Images

## 1.1.2 - 2021-02-15

### Changed
- Changed the CORS header for `craftcms/nginx:<ver>-dev` images to allow `*`.

### Fixed
- Fixed an issue with the Blackfire installation script for `php-fpm` and `nginx`.

## 1.1.1 - 2021-02-11

### Changed
- Removed Arm v6 and v7 builds to support the Blackfire extension.

## 1.1.0 - 2021-02-11

### Added
- Added the `blackfire` extension for all images. [#18](https://github.com/craftcms/docker/issues/18)

## 1.0.0 - 2021-02-05

### Added
- Added the `bcmath` extension to all images.
- Added php `7.0` images for `craftcms/cli`, `craftcms/php-fpm`, and `craftcms/nginx`.
- Added multi-architecture images for arm64, arm/v6, arm/v7, and amd64 to support ARM based development environments like Apple Silicon.
- Added an option `NGINX_CONF` ARG to the `craftcms/nginx` images to allow overriding the nginx configuration file to COPY to the image.
- Add PHP 8.0 images without imagick until [this upstream issue](https://github.com/Imagick/imagick/issues/358) is resolved.
- Added `craftcms/php-fpm:7.2`, `craftcms/php-fpm:7.2-dev`, `craftcms/nginx:7.4`, `craftcms/nginx:7.3`, `craftcms/nginx:7.2`, `craftcms/nginx:7.4-dev`, `craftcms/nginx:7.3-dev`, `craftcms/nginx:7.2-dev` images.
- Added `soap` extension to support Commerce ([#11](https://github.com/craftcms/docker/issues/11))

### Changed
- PHP `7.0` no longer ship with xdebug as `pecl` no longer supports 7.0 (e.g. `pecl/xdebug requires PHP (version >= 7.2.0, version <= 8.0.99), installed version is 7.0.33`).
- `craftcms/php-fpm:<ver>-dev` and `craftcms/nginx:<ver>-dev` images now include `git`.
- `craftcms/php-fpm:<ver>-dev` and `craftcms/nginx:<ver>-dev` images now include backup tools for mysql and postgres databases.
- All `-dev*` images now ship with composer installed by default.
