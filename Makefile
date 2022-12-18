
APPNAME := test-dotfiles-image

all: build-test-image
	docker run -it --name ${APPNAME} --rm \
    --mount type=bind,source="$(shell pwd)",target=/dotfiles \
    --net=host ${APPNAME}:latest

# all-ci is the same as 'all', but without -it, to make it runnable on CI
all-ci: build-test-image
	docker run --name ${APPNAME} --rm \
    --mount type=bind,source="$(shell pwd)",target=/dotfiles \
    --net=host ${APPNAME}:latest

# builds the docker image
.PHONY: build-test-image
build-test-image:
	docker build -t ${APPNAME} .

# override entrypoint to gain interactive shell
.PHONY: dshell
dshell:
	docker run --entrypoint /bin/bash -it --name ${APPNAME} --rm \
    --mount type=bind,source="$(shell pwd)",target=/dotfiles \
    --net=host ${APPNAME}
