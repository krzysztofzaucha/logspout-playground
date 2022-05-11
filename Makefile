export SHELL:=/bin/bash
export BASE_NAME:=$(shell basename ${PWD})
export IMAGE_BASE_NAME:=kz/$(shell basename ${PWD})
export NETWORK:=${BASE_NAME}-network

default: help

help: ## Prints help for targets with comments
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-50s\033[0m %s\n", $$1, $$2}'
	@echo ""

#########
# Build #
#########

clone: clean
	@mkdir -p tmp/gliderlabs
	@curl -Ls \
	  -H "authorization: token ${GITHUB_TOKEN}" \
	  -o tmp/gliderlabs/logspout.zip https://github.com/gliderlabs/logspout/archive/refs/heads/master.zip
	@unzip -q tmp/gliderlabs/logspout.zip -d tmp/gliderlabs || true

build: clone
	@podman image build -t "${IMAGE_BASE_NAME}-logspout:latest" -f "logspout/Dockerfile" .

clean:
	@rm -R -f tmp

#######
# Run #
#######

compose:
	@podman-compose ${COMPOSE} \
		-p ${BASE_NAME} \
		up -d --build --force-recreate --remove-orphans --abort-on-container-exit

up-logspout-papertrail: clone ## Start the Logspout with Papertrail example
	@COMPOSE=" -f docker-compose.yml -f logspout-papertrail.yml" make compose

up-logspout-grouping-papertrail: clone ## Start the Logspout grouping with Papertrail example
	@COMPOSE=" -f docker-compose.yml -f logspout-grouping-papertrail.yml" make compose

up-logspout-grafana: clone ## Start the Logspout with Grafana example
	@COMPOSE=" -f docker-compose.yml -f logspout-grafana.yml" make compose

down: ## Stop whatever is running
	@podman stop $(shell podman ps -aq) || true
	@podman system prune || true

###############
# Danger Zone #
###############

reset: ## Cleanup
	@podman stop $(shell podman ps -aq) || true
	@podman system prune || true
	@podman volume rm $(shell podman volume ls -q) || true
	@podman rmi -f ${IMAGE_BASE_NAME}-ping:latest || true
	@podman rmi -f ${IMAGE_BASE_NAME}-grafana:latest || true
	@podman rmi -f ${IMAGE_BASE_NAME}-fluentd:latest || true
	@podman rmi -f ${IMAGE_BASE_NAME}-logspout:latest || true
	@podman rmi -f ${IMAGE_BASE_NAME}-loki:latest || true
