-include .creds

BASEIMAGE := dragonflyscience/pycrown
IMAGE := $(BASEIMAGE):2023-05-04

profile := df
region := us-east-1

RUN ?= docker run -it --rm --net=host --user=$$(id -u):$$(id -g) -e DISPLAY=$$DISPLAY --env-file .creds -e RUN= -v$$(pwd):/work -w /work $(IMAGE)

# .PHONY

trees:
	$(RUN) python3 test-local.py

test-local: Dockerfile
	docker run -it --rm --net=host --user=$$(id -u):$$(id -g) \
	-e DISPLAY=$$DISPLAY \
	--env-file .creds \
	-e RUN= -v$$(pwd):/work \
	-w /work $(IMAGE) \
	bash

docker-local: Dockerfile
	docker build --tag $(BASEIMAGE) . && \
	docker tag $(BASEIMAGE) $(IMAGE)

docker: Dockerfile
	docker build --tag $(BASEIMAGE) . && \
	docker tag $(BASEIMAGE) $(IMAGE) && \
	docker push $(IMAGE) && \
	touch .push

docker-pull:
	docker pull $(IMAGE)