ORGANIZATION ?= craftcms
PROJECT ?= nginx
TAG ?= 7.4
IMAGE ?= ${ORGANIZATION}/${PROJECT}:${TAG}

.PHONY: build

build:
	docker build --build-arg PHP_VERSION=$(TAG) -t $(IMAGE) .
