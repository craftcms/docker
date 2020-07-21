ORGANIZATION ?= craftcms
PROJECT ?= php-fpm
PROJECT_TYPE ?= fpm
TAG ?= 7.4
IMAGE ?= ${ORGANIZATION}/${PROJECT}:${TAG}

.PHONY: build

build:
	docker build --build-arg PHP_VERSION=$(TAG) --build-arg PROJECT_TYPE=$(PROJECT_TYPE) -t $(IMAGE) .
dev:
	docker build -f dev.Dockerfile --build-arg PHP_VERSION=$(TAG) --build-arg PROJECT_TYPE=$(PROJECT_TYPE) -t $(IMAGE)-dev .
