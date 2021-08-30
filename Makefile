GIT_TAG ?= HEAD

IMG_TAG ?= develop

build:
	docker build -t storageos/manifests:$(IMG_TAG) --build-arg GIT_TAG=$(GIT_TAG) --build-arg IMG_TAG=$(IMG_TAG) .