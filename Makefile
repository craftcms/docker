ORGANIZATION ?= craftcms
PROJECT ?= php-fpm
TAG ?= 7.4
IMAGE ?= ${ORGANIZATION}/${PROJECT}:${TAG}

.PHONY: build

build:
	docker build --build-arg PHP_VERSION=$(TAG) -t $(IMAGE) .
dev:
	docker build -f dev.Dockerfile --build-arg PHP_VERSION=$(TAG) -t $(IMAGE)-dev .
