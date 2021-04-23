# Release Notes for Craft CMS Docker Images

## 1.2.8 - 2021-04-22

### Fixed
- Fixed an issue with the includes file on `dev` images.

## 1.2.7 - 2021-04-22

### Added
- Added an include to `/app/nitro.conf` to the `craftcms/nginx:<ver>-dev` images.

### Changed
- `/robots.txt` requests are now passed to `index.php` if the file does not exist.

## 1.2.6 - 2021-03-30

### Added
- Added GD JPEG support to PHP images. ([#25](https://github.com/craftcms/docker/issues/25))

## 1.2.5 - 2021-03-29

### Changed
- Expose ports 3000 and 3001 for tools such as nodejs.

## 1.2.4 - 2021-03-16

### Changed
- Nodejs and npm are now pre-installed in `craftcms/nginx:<ver>-dev` images.
- `craftcms/nginx:<ver>-dev` now exposes port 3000 as the "node" port.

## 1.2.3 - 2021-03-05

### Fixed
- Fixed a warning when installing Blackfire on ARM devices.

## 1.2.2 - 2021-03-05

### Added
- Added the Blackfire PHP extension.

## 1.2.1 - 2021-03-02

### Changed
- Added the mariadb-connector-c package to resolve issues with mysql 8.0 for `-dev` images [#19](https://github.com/craftcms/docker/issues/19).
- Allow `txt` files to be sent to PHP [#23](https://github.com/craftcms/docker/issues/23).

## 1.2.0 - 2021-02-25

### Fixed
- Fixed an issue with the iconv library [#16](https://github.com/craftcms/docker/issues/16).

## 1.1.4 - 2021-02-22

### Fixed
- Fixed a bug where requests for CSS, JS, font files, etc. were not being passed onto index.php when they 404.

## 1.1.3 - 2021-02-15

### Changed
- Removed the blackfire extension.

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
