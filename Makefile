.PHONY: build

LOCAL_PHP_VERSION ?= 8.0

build: all-cli all-cli-dev all-php-fpm all-php-fpm-dev all-nginx all-nginx-dev

all-cli:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.4 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.3 7.3

all-cli-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0-dev 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.4/dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.4-dev 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.3/dev.Dockerfile \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.3-dev 7.3

all-php-fpm:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:8.0 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.4 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.3 7.3

all-php-fpm-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:8.0-dev 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.4/dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.4-dev 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.3/dev.Dockerfile \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.3-dev 7.3

all-nginx:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		-t craftcms/nginx:8.0 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		-t craftcms/nginx:7.4 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		-t craftcms/nginx:7.3 nginx

all-nginx-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:8.0-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.4-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.3-dev nginx

setup:
	docker buildx create --name all-platforms --platform linux/amd64,linux/arm64
	docker buildx use all-platforms
	docker buildx inspect --bootstrap

local:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		-t craftcms/nginx:${LOCAL_PHP_VERSION} nginx
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION}-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:${LOCAL_PHP_VERSION}-dev nginx

run:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker run --rm -it craftcms/php-fpm:${LOCAL_PHP_VERSION} sh
