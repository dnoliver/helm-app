# Configuration
CHART_DIR := chart
DIST_DIR := dist

IMAGE_NAME := nginx
IMAGE_TAG := 1.31.1
DOCKER_ARCHIVE := $(DIST_DIR)/$(IMAGE_NAME)-$(IMAGE_TAG).tar

.PHONY: all helm docker clean

all: helm docker

$(DIST_DIR):
	mkdir -p $(DIST_DIR)

helm: $(DIST_DIR)
	helm package $(CHART_DIR) --destination $(DIST_DIR)

docker: $(DIST_DIR)
	docker pull --platform linux/amd64 $(IMAGE_NAME):$(IMAGE_TAG)
	docker save --platform linux/amd64 -o $(DOCKER_ARCHIVE) $(IMAGE_NAME):$(IMAGE_TAG)

clean:
	rm -rf $(DIST_DIR)