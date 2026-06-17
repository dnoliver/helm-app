# Configuration
CHART_DIR := chart
DIST_DIR := dist

REGISTRY := registry.panasonic.io:5000
IMAGE_NAME := nginx
IMAGE_TAG := 1.31.1
DOCKER_ARCHIVE := $(DIST_DIR)/docker/$(IMAGE_NAME)-$(IMAGE_TAG).tar
OCI_ARCHIVE := $(DIST_DIR)/oci/$(IMAGE_NAME)-$(IMAGE_TAG).tar

.PHONY: all app image clean

all: app image

$(DIST_DIR):
	mkdir -p $(DIST_DIR)
	mkdir -p $(DIST_DIR)/oci
	mkdir -p $(DIST_DIR)/docker

app: $(DIST_DIR)
	helm package $(CHART_DIR) --destination $(DIST_DIR)

image: $(DIST_DIR)
	docker pull --platform linux/amd64 $(IMAGE_NAME):$(IMAGE_TAG)
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker save --platform linux/amd64 -o $(DOCKER_ARCHIVE) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	skopeo copy docker-daemon:$(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) oci-archive:$(OCI_ARCHIVE):$(IMAGE_NAME):$(IMAGE_TAG)

clean:
	rm -rf $(DIST_DIR)